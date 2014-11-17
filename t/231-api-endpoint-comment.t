#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

# TODO: Avoid an error when installing GoogleAnalytics plugin.
my $mock_cms_common = Test::MockModule->new('MT::CMS::Common');
$mock_cms_common->mock( 'run_web_services_save_config_callbacks', sub { } );

$app->config->allowComments(1);

my @suite = (
    {   path      => '/v1/sites/1/comments',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.comment',
                count => 2,
            },
        ],
    },
    {   path      => '/v1/sites/1/entries/1/comments',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.comment',
                count => 2,
            },
        ],
    },
    {   path   => '/v1/sites/1/entries/1/comments',
        method => 'POST',
        params => { comment => { body => 'test-api-endopoint-comment', }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.comment',
                count => 1,
            },
        ],
        result => sub {
            MT->model('comment')->load(
                {   text        => 'test-api-endopoint-comment',
                    visible     => 1,
                    junk_status => MT::Comment::NOT_JUNK(),
                },
                {   sort      => 'id',
                    direction => 'descend',
                },
            );
        },
    },
    {   path      => '/v1/sites/1/entries/1/comments/1/replies',
        method    => 'POST',
        params    => { comment => { body => 'test-api-endopoint-reply', }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.comment',
                count => 1,
            },
        ],
        result => sub {
            MT->model('comment')->load(
                {   text        => 'test-api-endopoint-reply',
                    visible     => 1,
                    junk_status => MT::Comment::NOT_JUNK(),
                    parent_id   => 1,
                },
                {   sort      => 'id',
                    direction => 'descend',
                },
            );
        },
    },
    {   path      => '/v1/sites/1/comments/1',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.comment',
                count => 1,
            },
        ],
        result => sub {
            MT->model('comment')->load(1);
        },
    },
    {   path   => '/v1/sites/1/comments/1',
        method => 'PUT',
        params => {
            comment => {
                body   => 'update-test-api-permission-comment',
                status => 'Pending'
            },
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.comment',
                count => 1,
            },
        ],
        result => sub {
            MT->model('comment')->load(
                {   id          => 1,
                    text        => 'update-test-api-permission-comment',
                    visible     => 0,
                    junk_status => MT::Comment::NOT_JUNK(),
                }
            );
        },
    },
    {   note   => 'reply to pending comment',
        path   => '/v1/sites/1/entries/1/comments/1/replies',
        method => 'POST',
        params => {
            comment =>
                { body => 'test-api-endopoint-reply-to-pending-comment', },
        },
        code => '409',
    },
    {   setup => sub {
            my ($data) = @_;
            $data->{comment} = MT->model('comment')->load(
                { text => 'test-api-endopoint-reply', },
                {   sort      => 'id',
                    direction => 'descend',
                },
            );
        },
        note   => 'Update status when parent comment is pending',
        path   => '/v1/sites/1/comments/:comment_id',
        method => 'PUT',
        params => { comment => { status => 'Pending' }, },
        result => sub {
            MT->model('comment')->load(
                {   text        => 'test-api-endopoint-reply',
                    visible     => 0,
                    junk_status => MT::Comment::NOT_JUNK(),
                    parent_id   => 1,
                },
                {   sort      => 'id',
                    direction => 'descend',
                },
            );
        },
    },
    {   note   => 'status: Approved',
        path   => '/v1/sites/1/comments/1',
        method => 'PUT',
        params => { comment => { status => 'Approved' }, },
        result => sub {
            MT->model('comment')->load(
                {   id          => 1,
                    text        => 'update-test-api-permission-comment',
                    visible     => 1,
                    junk_status => MT::Comment::NOT_JUNK(),
                }
            );
        },
    },
    {   setup => sub {
            my ($data) = @_;
            $data->{comment} = MT->model('comment')->load(
                { text => 'test-api-endopoint-reply', },
                {   sort      => 'id',
                    direction => 'descend',
                },
            );
        },
        path      => '/v1/sites/1/comments/:comment_id',
        method    => 'DELETE',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.comment',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_delete.comment',
                count => 1,
            },
        ],
        complete => sub {
            my ( $data, $body ) = @_;
            my $deleted = MT->model('comment')->load( $data->{comment}->id );
            is( $deleted, undef, 'deleted' );
        },
    },

    # Cannot comment to the entry whose allowComments is 0.
    {   path   => '/v1/sites/1/entries/1',
        method => 'PUT',
        params => { entry => { allowComments => 0 }, },
    },
    {   note   => 'post comment to an entry whose allowComments is false',
        path   => '/v1/sites/1/entries/1/comments',
        method => 'POST',
        params => { comment => { body => 'test-api-endopoint-comment', }, },
        code   => '409',
    },
    {   note   => 'reply comment to an entry whose allowComments is false',
        path   => '/v1/sites/1/entries/1/comments/1/replies',
        method => 'POST',
        params => { comment => { body => 'test-api-endopoint-reply', }, },
        code   => 409,
    },
    {   path   => '/v1/sites/1/entries/1',
        method => 'PUT',
        params => { entry => { allowComments => 1 }, },
    },

    # Cannot comment when the blog's "allowComments" is false.
    {   path   => '/v2/sites/1',
        method => 'PUT',
        params => { blog => { allowComments => 0, }, },
    },
    {   note =>
            'post comment to an entry whose blog\'s allowComments is false',
        path   => '/v1/sites/1/entries/1/comments',
        method => 'POST',
        params => { comment => { body => 'test-api-endopoint-comment', }, },
        code   => '409',
    },
    {   note   => 'reply comment to an entry whose allowComments is false',
        path   => '/v1/sites/1/entries/1/comments/1/replies',
        method => 'POST',
        params => { comment => { body => 'test-api-endopoint-reply', }, },
        code   => 409,
    },
    {   path   => '/v2/sites/1',
        method => 'PUT',
        params => { blog => { allowComments => 1, }, },
    },

    # Cannot comment when config directive "AllowComments" is false.
    {   path   => '/v1/sites/1/entries/1/comments',
        setup  => sub { $app->config->AllowComments(0) },
        method => 'POST',
        params => { comment => { body => 'test-api-endopoint-comment', }, },
        code   => '409',
        complete => sub { $app->config->AllowComments(1) },
    },
);

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

my $format = MT::DataAPI::Format->find_format('json');

for my $data (@suite) {
    $data->{setup}->($data) if $data->{setup};

    my $path = $data->{path};
    $path
        =~ s/:(?:(\w+)_id)|:(\w+)/ref $data->{$1} ? $data->{$1}->id : $data->{$2}/ge;

    my $params
        = ref $data->{params} eq 'CODE'
        ? $data->{params}->($data)
        : $data->{params};

    my $note = $path;
    if ( lc $data->{method} eq 'get' && $data->{params} ) {
        $note .= '?'
            . join( '&',
            map { $_ . '=' . $data->{params}{$_} }
                keys %{ $data->{params} } );
    }
    $note .= ' ' . $data->{method};
    $note .= ' ' . $data->{note} if $data->{note};
    note($note);

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $path,
            __request_method => $data->{method},
            ( $data->{upload} ? ( __test_upload => $data->{upload} ) : () ),
            (   $params
                ? map {
                    $_ => ref $params->{$_}
                        ? MT::Util::to_json( $params->{$_} )
                        : $params->{$_};
                    }
                    keys %{$params}
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $headers, $body ) = split /^\s*$/m, $out, 2;
    my %headers = map {
        my ( $k, $v ) = split /\s*:\s*/, $_, 2;
        $v =~ s/(\r\n|\r|\n)\z//;
        lc $k => $v
        }
        split /\n/, $headers;
    my $expected_status = $data->{code} || 200;
    is( $headers{status}, $expected_status, 'Status ' . $expected_status );
    if ( $data->{next_phase_url} ) {
        like(
            $headers{'x-mt-next-phase-url'},
            $data->{next_phase_url},
            'X-MT-Next-Phase-URL'
        );
    }

    foreach my $cb ( @{ $data->{callbacks} } ) {
        my $params_list = $callbacks{ $cb->{name} } || [];
        if ( my $params = $cb->{params} ) {
            for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                is_deeply( $params_list->[$i], $cb->{params}[$i] );
            }
        }

        if ( my $c = $cb->{count} ) {
            is( @$params_list, $c,
                $cb->{name} . ' was called ' . $c . ' time(s)' );
        }
    }

    if ( my $expected_result = $data->{result} ) {
        $expected_result = $expected_result->( $data, $body )
            if ref $expected_result eq 'CODE';
        if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
            MT->instance->user($author);
            $expected_result = $format->{unserialize}->(
                $format->{serialize}->(
                    MT::DataAPI::Resource->from_object($expected_result)
                )
            );
        }

        my $result = $format->{unserialize}->($body);
        is_deeply( $result, $expected_result, 'result' );
    }

    if ( my $complete = $data->{complete} ) {
        $complete->( $data, $body );
    }
}

done_testing();

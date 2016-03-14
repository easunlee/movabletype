<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('stats_lib.php');

function smarty_function_mtstatssnippet($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $provider = Stats::readied_provider($ctx->stash('blog'));
    if (empty($provider)) {
        return '';
    }

    return $provider->snippet($args, $ctx);
}

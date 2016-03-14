<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitedatelanguage($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $blog = $ctx->stash('blog');
    if (!empty($blog)) {
        if ($blog->is_blog()) {
            $website = $blog->website();
            if (empty($website)) return '';
        } else {
            $website = $blog;
        }
    }
    $date_language = empty($website)
        ? $ctx->mt->config('DefaultLanguage')
        : $website->blog_date_language;
    return normalize_language( $date_language, $args['locale'],
        $args['ietf'] );
}
?>

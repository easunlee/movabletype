<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtwebsitehasblog($args, $content, &$_smarty_tpl, &$repeat) {
    $ctx =& $_smarty_tpl->smarty;
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if (empty($blog)) {
            $ret = false;
        } else if($blog->class == 'blog') {
            $website = $blog->website();
            $ret = empty($website)
                ? false
                : true;
        } else {
            $blogs = $blog->blogs();
            $ret = empty($blogs)
                ? false
                : true;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ret);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>

<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtblogcclicenseurl($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $blog = $ctx->stash('blog');
    $cc = $blog->blog_cc_license;
    if (empty($cc)) return '';
    require_once("cc_lib.php");
    return cc_url($cc);
}
?>

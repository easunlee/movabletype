<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtpingexcerpt($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $ping = $ctx->stash('ping');
    return $ping->tbping_excerpt;
}
?>

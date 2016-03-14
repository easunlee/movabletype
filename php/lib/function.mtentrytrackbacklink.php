<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrytrackbacklink($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    $tb = $entry->trackback();
    if (!$tb) return '';
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $_smarty_tpl);
    $path .= $ctx->mt->config('TrackbackScript') . '/' . $tb->trackback_id;
    return $path;
}
?>

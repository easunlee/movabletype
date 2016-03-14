<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttagcount($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $tag = $ctx->stash('Tag');
    $count = 0;
    if ($tag && is_object($tag)) {
        $count = $tag->tag_count;
        if($count == ''){
            $count = $ctx->mt->db()->tags_entry_count($tag->tag_id, $ctx->stash('class_type'));
        }
     }
    return $ctx->count_format($count, $args);
}
?>

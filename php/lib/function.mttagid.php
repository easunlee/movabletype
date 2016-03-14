<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttagid($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        return $tag->tag_id;
    } else {
        $tag = $ctx->mt->db()->fetch_tag_by_name($tag);
        if ($tag) {
            $ctx->stash('Tag', $tag);
            return $tag->tag_id;
        }
        return '';
    }
}
?>

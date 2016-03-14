<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcommentername($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $a =& $ctx->stash('commenter');
    $name = isset($a) ? $a->author_nickname : '';
    if ($name == '') {
        $name = $ctx->tag('CommentName');
    }
    return $name;
}
?>

<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mthassubcategories.php');
function smarty_block_mthassubfolders($args, $content, &$_smarty_tpl, &$repeat) {
    $ctx =& $_smarty_tpl->smarty;
    $args['class'] = 'folder';
    return smarty_block_mthassubcategories($args, $content, $_smarty_tpl, $repeat);
}
?>

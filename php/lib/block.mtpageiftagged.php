<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mtentryiftagged.php');
function smarty_block_mtpageiftagged($args, $content, &$_smarty_tpl, &$repeat) {
    $ctx =& $_smarty_tpl->smarty;
    $args['class'] = 'page';
    return smarty_block_mtentryiftagged($args, $content, $_smarty_tpl, $repeat);
}
?>

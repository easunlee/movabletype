<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtcategorylabel.php');
function smarty_function_mtfolderlabel($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    return smarty_function_mtcategorylabel($args, $_smarty_tpl);
}
?>

<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcommenternamethunk($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    return $ctx->error(
        $ctx->mt->translate("The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.",
            array( 'MTCommenterNameThunk', 'MTUserSessionState' )
    ));
}
?>

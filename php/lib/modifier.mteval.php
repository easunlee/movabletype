<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_mteval($text, $arg) {
    if (!$arg) return $text;

    $mt = MT::get_instance();
    $ctx =& $mt->context();
    $_var_compiled = '';
    $_var_compiled = $ctx->fetch("eval:$text");
    if (!$_var_compiled) {
        return $ctx->error("Error compiling text '$text'");
    }
    ob_start();
    eval('?>' . $_var_compiled);
    $_contents = ob_get_contents();
    ob_end_clean();
    return $_contents;
}
?>

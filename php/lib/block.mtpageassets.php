<?php
# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("block.mtassets.php");
function smarty_block_mtpageassets($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtassets($args, $content, $ctx, $repeat);
}
?>

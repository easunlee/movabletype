<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_ja;
$Lexicon_ja = array(

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/archive_lib.php
	'Individual' => 'ブログ記事',
	'Page' => 'ウェブページ',
	'Yearly' => '年別',
	'Monthly' => '月別',
	'Daily' => '日別',
	'Weekly' => '週別',
	'Author' => 'ユーザー',
	'(Display Name not set)' => '(表示名なし)',
	'Author Yearly' => 'ユーザー 年別',
	'Author Monthly' => 'ユーザー 月別',
	'Author Daily' => 'ユーザー 日別',
	'Author Weekly' => 'ユーザー 週別',
	'Category Yearly' => 'カテゴリ 年別',
	'Category Monthly' => 'カテゴリ 月別',
	'Category Daily' => 'カテゴリ 日別',
	'Category Weekly' => 'カテゴリ 週別',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'ユーザーが見つかりません。',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3]は不正です。',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '[_1]はハッシュではありません。',
	'Invalid index.' => '不正なインデックスです。',
	'\'[_1]\' is not an array.' => '[_1]は配列ではありません。',
	'\'[_1]\' is not a valid function.' => '[_1]という関数はサポートされていません。',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => '画像の中に見える文字を入力してください。',

## php/lib/function.mtassettype.php
	'image' => '画像',
	'Image' => '画像',
	'file' => 'ファイル',
	'File' => 'ファイル',
	'audio' => 'オーディオ',
	'Audio' => 'オーディオ',
	'video' => 'ビデオ',
	'Video' => 'ビデオ',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthor.php
	'Anonymous' => '匿名',

## php/lib/function.mtcommentauthorlink.php

## php/lib/function.mtcommenternamethunk.php
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'テンプレートタグ \'[_1]\' は廃止されました。代わりに \'[_2]\'を使用してください。',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => '返信',

## php/lib/function.mtentryclasslabel.php
	'page' => 'ウェブページ',
	'entry' => 'ブログ記事',
	'Entry' => 'ブログ記事',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => '\'parent\'属性を[_1]属性と同時に指定することは出来ません。',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'パスワードは最低[_1]文字以上です。',
	'Password should not include your Username' => 'パスワードにユーザー名を含む事は出来ません。',
	'Password should include letters and numbers' => 'パスワードは文字と数字を含める必要があります。',
	'Password should include lowercase and uppercase letters' => 'パスワードは大文字と小文字を含める必要があります。',
	'Password should contain symbols such as #!$%' => 'パスワードは記号を含める必要があります。',
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]タグでは[_2]属性は必須です。',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => '[_1]文字以上',
	', uppercase and lowercase letters' => '、大文字と小文字を含む',
	', letters and numbers' => '、文字と数字を含む',
	', symbols (such as #!$%)' => '、記号を含む',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'ブログでTypePad認証を有効にしていないので、MTRemoteSignInLinkは利用できません。',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => '[_1]パラメータが不正です。',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '[_1]はハッシュで利用できる関数ではありません。',
	'\'[_1]\' is not a valid function for an array.' => '[_1]は配列で利用できる関数ではありません。',

## php/lib/function.mtwidgetmanager.php
	'Error compiling widgetset [_1]' => 'ウィジェットセット[_1]をコンパイルできませんでした。',

## php/lib/mtdb.base.php
	'The attribute exclude_blogs denies all include_blogs.' => 'include_blogs属性で指定されたブログがexclude_blogs属性で全て除外されています。',

## php/mt.php
	'Page not found - [_1]' => '[_1]が見つかりませんでした。',

## php/lib/MTViewer.php
	'moments from now' => '今から',
	'[quant,_1,hour,hours] from now' => '[quant,_1,時間,時間]後',
	'[quant,_1,minute,minutes] from now' => '[quant,_1,分,分]後',
	'[quant,_1,day,days] from now' => '[quant,_1,日,日]後',
	'less than 1 minute from now' => '1分後以内',
	'less than 1 minute ago' => '1分以内',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => '[quant,_1,時間,時間], [quant,_2,分,分]後',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,時間,時間], [quant,_2,分,分]前',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => '[quant,_1,日,日], [quant,_2,時間,時間]後',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,日,日], [quant,_2,時間,時間]前',
	'[quant,_1,second,seconds] from now' => '[quant,_1,秒,秒]後',
	'[quant,_1,second,seconds]' => '[quant,_1,秒,秒]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => '[quant,_1,分,分], [quant,_2,秒,秒]後',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,分,分], [quant,_2,秒,秒]',
	'[quant,_1,minute,minutes]' => '[quant,_1,分,分]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,時間,時間], [quant,_2,分,分]',
	'[quant,_1,hour,hours]' => '[quant,_1,時間,時間]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,日,日], [quant,_2,時間,時間]',
	'[quant,_1,day,days]' => '[quant,_1,日,日]',


);
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon_ja[$str]) ? $Lexicon_ja[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>

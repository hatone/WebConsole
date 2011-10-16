#!/usr/bin/perl
#
# WEB CONSOLE: WEB-BASED REMOTE CONSOLE
# Copyright 2008-2010 Nickolay Kovalev, http://resume.nickola.ru
# Web Console version: '0.2.6' (build date: '2010.11.12')
# Web Console URL: http://www.web-console.org
# Web Console license: GNU GPLv3 (http://www.gnu.org/licenses/)
# Web Console Group services: http://services.web-console.org
#
# Latest version of Web Console can be downloaded here: http://www.web-console.org/download/
#
# ** Web Console Group provides web application development, server configuration,
# ** technical support, security analysis, consulting and other services.
# ** To get more information, please visit to: http://services.web-console.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Used JS libraries:
# - JsHttpRequest, http://en.dklab.ru/lib/JsHttpRequest/ [license: GNU LGPL]
# - X, http://www.cross-browser.com [license: GNU LGPL]
#
# ** WARNING:
# ** PERL/CSS/JS CODE ARE COMPRESSED (TO INCREASE PERFORMANCE AND MINIMIZE STARTUP TIME)
# ** UNCOMPRESSED SOURCES AVALIABLE HERE: http://www.web-console.org/download/
#
use strict;
package NL;
use strict;
package NL::Error;
use strict;
$NL::Error::DATA={'ERROR_OBJECTS'=>{}};
sub reset{my($obj_id)=@_;
if(defined$obj_id&&$obj_id ne ''&&defined$NL::Error::DATA->{'ERROR_OBJECTS'}->{$obj_id}){delete$NL::Error::DATA->{'ERROR_OBJECTS'}->{$obj_id};}}sub set{my($obj_id,$err_text,$err_info,$err_id)=@_;
if(defined$obj_id&&$obj_id ne ''){$NL::Error::DATA->{'ERROR_OBJECTS'}->{$obj_id}={'ERROR_ID'=>(defined$err_id)?$err_id:'','ERROR_TEXT'=>(defined$err_text)?$err_text:'','ERROR_INFO'=>(defined$err_info)?$err_info:''};}}sub get{my($obj_id)=@_;
if(defined$obj_id&&$obj_id ne ''&&defined$NL::Error::DATA->{'ERROR_OBJECTS'}->{$obj_id}){return$NL::Error::DATA->{'ERROR_OBJECTS'}->{$obj_id};}return{};}sub _get{my($obj_id,$hash_element)=@_;
my$ref_hash=&get($obj_id);
if(defined$ref_hash->{$hash_element}){return$ref_hash->{$hash_element};}return '';}sub get_ARR{my($obj_id)=@_;
my$ref_hash=&get($obj_id);
if(scalar keys%{$ref_hash}>0){return($ref_hash->{'ERROR_TEXT'},$ref_hash->{'ERROR_INFO'},$ref_hash->{'ERROR_ID'});}else{return('','','');}}sub get_id{return&_get($_[0],'ERROR_ID');}sub get_text{return&_get($_[0],'ERROR_TEXT');}sub get_info{return&_get($_[0],'ERROR_INFO');}package NL::Utils;
use strict;
sub hash_merge{my($in_ref_hash_TO,$in_ref_hash_FROM,$in_UPDATE)=@_;
$in_UPDATE=0 if(!defined$in_UPDATE);
foreach(keys%{$in_ref_hash_FROM}){if(!defined$in_ref_hash_TO->{$_}){$in_ref_hash_TO->{$_}=$in_ref_hash_FROM->{$_};}else{my$val_TO_REF=ref$in_ref_hash_TO->{$_};
my$val_FROM_REF=ref$in_ref_hash_FROM->{$_};
if(defined$val_TO_REF&&$val_TO_REF eq 'HASH'&&defined$val_FROM_REF&&$val_FROM_REF eq 'HASH'){&hash_merge($in_ref_hash_TO->{$_},$in_ref_hash_FROM->{$_},$in_UPDATE);}elsif($in_UPDATE){$in_ref_hash_TO->{$_}=$in_ref_hash_FROM->{$_};}}}}sub hash_update{return&hash_merge(defined$_[0]?$_[0]:'',defined$_[1]?$_[1]:'',1);}sub hash_foreach_REF{my($in_REF_HASH,$in_REF_SUB)=@_;
foreach(keys%{$in_REF_HASH}){my$val_REF=ref$in_REF_HASH->{$_}||'';
if($val_REF eq 'HASH'){&hash_foreach_REF($in_REF_HASH->{$_},$in_REF_SUB);}elsif($val_REF eq 'ARRAY'){foreach my $val(@{$in_REF_HASH->{$_}}){my$val_REF_ARR=ref$val||'';
if($val_REF_ARR eq 'HASH'){&hash_foreach_REF($val,$in_REF_SUB);}else{&{$in_REF_SUB}(\$val);}}}else{&{$in_REF_SUB}(\$in_REF_HASH->{$_});}}}sub hash_remove_empty_values{my($in_REF_HASH)=@_;
if(defined$in_REF_HASH&&ref$in_REF_HASH){foreach(keys%{$in_REF_HASH}){my$val_REF=$in_REF_HASH->{$_};
if(defined$val_REF){if($val_REF eq 'HASH'){&hash_remove_empty_values($in_REF_HASH->{$_});
if(scalar keys%{$in_REF_HASH->{$_}}<=0){delete$in_REF_HASH->{$_}}}}else{if($in_REF_HASH->{$_}eq ''){delete$in_REF_HASH->{$_}}}}}}sub hash_clone{my($in_ref_hash_TO,$in_ref_hash_FROM)=@_;
if(defined$in_ref_hash_TO&&defined$in_ref_hash_FROM){foreach(keys%{$in_ref_hash_FROM}){my$val_FROM_REF=ref$in_ref_hash_FROM->{$_};
if(defined$val_FROM_REF&&$val_FROM_REF eq 'HASH'){$in_ref_hash_TO->{$_}={};
&hash_clone($in_ref_hash_TO->{$_},$in_ref_hash_FROM->{$_});}else{$in_ref_hash_TO->{$_}=$in_ref_hash_FROM->{$_};}}}}package NL::Parameter;
use strict;
sub FUNC_CHECK_email{my($in_value)=@_;
if(defined$in_value&&$in_value=~/^[a-zA-Z0-9_\.\-]{1,}\@[a-zA-Z0-9_\.\-]{1,}\.[a-zA-Z]{2,}$/){return{'ID'=>1,'ERROR_MESSAGE'=>''};}return{'ID'=>0,'ERROR_MESSAGE'=>''};}sub FUNC_CHECK_directory{my($in_value)=@_;
if(defined$in_value&&$in_value ne ''){if(-d$in_value){return{'ID'=>1,'ERROR_MESSAGE'=>''};}else{return{'ID'=>0,'ERROR_MESSAGE'=>'not found (directory should exists)'};}}return{'ID'=>0,'ERROR_MESSAGE'=>''};}sub check{my($in_PARAMETERS,$in_CHECK)=@_;
my$result={'ID'=>1,'ERROR_MESSAGE'=>''};
if(defined$in_PARAMETERS&&defined$in_CHECK){foreach(keys%{$in_CHECK}){my($is_undefined,$is_empty)=(0,0);
my($PARAM,$is_FOUND)=($in_PARAMETERS,0);
if($_=~/\|/){$is_FOUND=1;
foreach my $part(split/\|/,$_){if(ref$PARAM&&defined$PARAM->{$part}){$PARAM=$PARAM->{$part};}else{$is_FOUND=0;last;}}}else{if(defined$PARAM->{$_}){$is_FOUND=1;
$PARAM=$PARAM->{$_};}}if($is_FOUND){if(!ref$PARAM){if($PARAM ne ''){if(defined$in_CHECK->{$_}->{'func_CHECK'}&&ref$in_CHECK->{$_}->{'func_CHECK'}eq 'CODE'){my$check_RESULT=&{$in_CHECK->{$_}->{'func_CHECK'}}($PARAM);
if(!$check_RESULT->{'ID'}){$result={'ID'=>0,'ERROR_MESSAGE'=>'"'.$in_CHECK->{$_}->{'name'}.'" '.($check_RESULT->{'ERROR_MESSAGE'}ne ''?$check_RESULT->{'ERROR_MESSAGE'}:'is incorrect').'...'};
last;}}if(defined$in_CHECK->{$_}->{'func_HOOK'}&&ref$in_CHECK->{$_}->{'func_HOOK'}eq 'CODE'){&{$in_CHECK->{$_}->{'func_HOOK'}}($PARAM);}if(defined$in_CHECK->{$_}->{'func_ENCODE'}&&ref$in_CHECK->{$_}->{'func_ENCODE'}eq 'CODE'){my$encode_result=&{$in_CHECK->{$_}->{'func_ENCODE'}}($PARAM);
if($encode_result->[0]==1){$PARAM=$encode_result->[1];}else{$result={'ID'=>0,'ERROR_MESSAGE'=>'"'.$in_CHECK->{$_}->{'name'}.'" can\'t be encoded...'};
last;}}}else{if(defined$in_CHECK->{$_}->{'if_undefined_or_empty_set'}){&set($in_PARAMETERS,{$_=>$in_CHECK->{$_}->{'if_undefined_or_empty_set'}});}else{$is_empty=1;}}}else{}}else{if(defined$in_CHECK->{$_}->{'if_undefined_or_empty_set'}){&set($in_PARAMETERS,{$_=>$in_CHECK->{$_}->{'if_undefined_or_empty_set'}});}else{$is_undefined=1;}}if($is_empty&&(defined$in_CHECK->{$_}->{'can_be_empty'}&&!$in_CHECK->{$_}->{'can_be_empty'})){$result={'ID'=>0,'ERROR_MESSAGE'=>'"'.$in_CHECK->{$_}->{'name'}.'" can\'t be empty...'};
last;}elsif($is_undefined&&(defined$in_CHECK->{$_}->{'needed'}&&$in_CHECK->{$_}->{'needed'})){$result={'ID'=>0,'ERROR_MESSAGE'=>'"'.$in_CHECK->{$_}->{'name'}.'" must be defined...'};
last;}}}else{$result->{'ID'}=0;}return$result;}sub make_groups{my($in_PARAMETERS,$in_GROUPS_CONFIG)=@_;
my@keys_PARAMETERS=keys%{$in_PARAMETERS};
foreach my $key_code(keys%{$in_GROUPS_CONFIG}){my$new_HASH={};
foreach(grep (/^$key_code/,@keys_PARAMETERS)){my$name=$_;
$name=~s/^$key_code//;
$new_HASH->{$name}=$in_PARAMETERS->{$_};
delete$in_PARAMETERS->{$_};}if(scalar keys%{$new_HASH}>0){if(ref$in_GROUPS_CONFIG->{$key_code}){if(defined$in_GROUPS_CONFIG->{$key_code}->{'*'}){my$name=$in_GROUPS_CONFIG->{$key_code}->{'*'};
delete$in_GROUPS_CONFIG->{$key_code}->{'*'};
&make_groups($new_HASH,$in_GROUPS_CONFIG->{$key_code});
if(defined$in_PARAMETERS->{$name}){&add($in_PARAMETERS->{$name},$new_HASH,{'REPLACE'=>1});}else{$in_PARAMETERS->{$name}=$new_HASH;}}}else{if(defined$in_PARAMETERS->{$in_GROUPS_CONFIG->{$key_code}}){&add($in_PARAMETERS->{$in_GROUPS_CONFIG->{$key_code}},$new_HASH,{'REPLACE'=>1});}else{$in_PARAMETERS->{$in_GROUPS_CONFIG->{$key_code}}=$new_HASH;}}}}}sub set{my($in_PARAMETERS,$in_VALUES)=@_;
if(defined$in_PARAMETERS&&defined$in_VALUES&&ref$in_PARAMETERS&&ref$in_VALUES){foreach my $key(keys%{$in_VALUES}){if($key=~/\|/){my($PARAM,$is_EXISTS)=($in_PARAMETERS,1);
my($last_PARAM,$last_part)=('','');
foreach my $part(split/\|/,$key){if(!$is_EXISTS||!defined$PARAM->{$part}||!ref$PARAM->{$part}){$is_EXISTS=0;
$PARAM->{$part}={};}$last_part=$part;
$last_PARAM=$PARAM;
$PARAM=$PARAM->{$part};}$last_PARAM->{$last_part}=$in_VALUES->{$key};}else{$in_PARAMETERS->{$key}=$in_VALUES->{$key};}}}}sub remove{my($in_PARAMETERS,$in_VALUES,$in_SETTINGS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
foreach('REMOVE_NODES'){$in_SETTINGS->{$_}=0 if(!defined$in_SETTINGS->{$_});}if(defined$in_PARAMETERS&&defined$in_VALUES&&ref$in_PARAMETERS&&ref$in_VALUES){foreach my $key(@{$in_VALUES}){if($key=~/\|/){my($PARAM,$last_PARAM,$pre_last_PARAM)=($in_PARAMETERS,$in_PARAMETERS,$in_PARAMETERS);
my($is_EXISTS,$last_part,$pre_last_part)=(1,'','');
foreach my $part(split/\|/,$key){if(!defined$PARAM->{$part}){$is_EXISTS=0;last;}$pre_last_part=$last_part;
$pre_last_PARAM=$last_PARAM;
$last_part=$part;
$last_PARAM=$PARAM;
$PARAM=$PARAM->{$part};}if($is_EXISTS){delete$last_PARAM->{$last_part};
if($in_SETTINGS->{'REMOVE_NODES'}&&$pre_last_part ne ''&&scalar keys%{$pre_last_PARAM->{$pre_last_part}}<=0){$key=~s/\|[^\|]{0,}$//;
&remove($in_PARAMETERS,[$key],$in_SETTINGS);}}}elsif(defined$in_PARAMETERS->{$key}){delete$in_PARAMETERS->{$key};}}}}sub grab{my($in_PARAMETERS,$in_VALUES,$in_SETTINGS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
foreach('REMOVE_FROM_SOURCE','SET_NOT_FOUND_EMPTY','REMOVE_FROM_SOURCE_NODES'){$in_SETTINGS->{$_}=0 if(!defined$in_SETTINGS->{$_});}$in_SETTINGS->{'func_ENCODE'}=0 if(!defined$in_SETTINGS->{'func_ENCODE'});
my$result={};
if(defined$in_PARAMETERS&&defined$in_VALUES&&ref$in_PARAMETERS&&ref$in_VALUES){foreach my $key(@{$in_VALUES}){my$is_EXISTS=0;
if($key=~/\|/){$is_EXISTS=1;
my($PARAM,$last_PARAM,$pre_last_PARAM)=($in_PARAMETERS,$in_PARAMETERS,$in_PARAMETERS);
my($last_part,$pre_last_part)=('','');
foreach my $part(split/\|/,$key){if(!defined$PARAM->{$part}){$is_EXISTS=0;last;}$pre_last_part=$last_part;
$pre_last_PARAM=$last_PARAM;
$last_part=$part;
$last_PARAM=$PARAM;
$PARAM=$PARAM->{$part};}if($is_EXISTS){&set($result,{$key=>($in_SETTINGS->{'func_ENCODE'})?&{$in_SETTINGS->{'func_ENCODE'}}($last_PARAM->{$last_part}):$last_PARAM->{$last_part}});
if($in_SETTINGS->{'REMOVE_FROM_SOURCE'}){&remove($in_PARAMETERS,[$key],{'REMOVE_NODES'=>$in_SETTINGS->{'REMOVE_FROM_SOURCE_NODES'}});}}}elsif(defined$in_PARAMETERS->{$key}){$is_EXISTS=1;
&set($result,{$key=>($in_SETTINGS->{'func_ENCODE'})?&{$in_SETTINGS->{'func_ENCODE'}}($in_PARAMETERS->{$key}):$in_PARAMETERS->{$key}});
if($in_SETTINGS->{'REMOVE_FROM_SOURCE'}){delete$in_PARAMETERS->{$key};}}if(!$is_EXISTS&&$in_SETTINGS->{'SET_NOT_FOUND_EMPTY'}){&set($result,{$key=>''});}}}return$result;}sub add{my($in_ref_hash_TO,$in_ref_hash_FROM,$in_SETTINGS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
foreach('REPLACE'){$in_SETTINGS->{$_}=0 if(!defined$in_SETTINGS->{$_});}foreach(keys%{$in_ref_hash_FROM}){if(!defined$in_ref_hash_TO->{$_}){$in_ref_hash_TO->{$_}=$in_ref_hash_FROM->{$_};}else{my$val_TO_REF=ref$in_ref_hash_TO->{$_};
my$val_FROM_REF=ref$in_ref_hash_FROM->{$_};
if(defined$val_TO_REF&&$val_TO_REF eq 'HASH'&&defined$val_FROM_REF&&$val_FROM_REF eq 'HASH'){&add($in_ref_hash_TO->{$_},$in_ref_hash_FROM->{$_},$in_SETTINGS);}elsif($in_SETTINGS->{'REPLACE'}){$in_ref_hash_TO->{$_}=$in_ref_hash_FROM->{$_};}}}}sub clone{my($in_ref_hash_TO,$in_ref_hash_FROM)=@_;
if(defined$in_ref_hash_TO&&defined$in_ref_hash_FROM){foreach(keys%{$in_ref_hash_FROM}){my$val_FROM_REF=ref$in_ref_hash_FROM->{$_};
if(defined$val_FROM_REF&&$val_FROM_REF eq 'HASH'){$in_ref_hash_TO->{$_}={};
&clone($in_ref_hash_TO->{$_},$in_ref_hash_FROM->{$_});}else{$in_ref_hash_TO->{$_}=$in_ref_hash_FROM->{$_};}}}}package NL::CGI;
use strict;
$NL::CGI::DATA={'CONST'=>{},'DYNAMIC'=>{'ENABLE_MULTI_VALUES'=>0}};
our$CRLF='';
if($^O=~/^VMS/i){$CRLF="\n";}elsif("\t" ne"\011"){$CRLF="\r\n";}else{$CRLF="\015\012";}our$CRLF_len=length($CRLF);
sub init{my($in_SUB_decode_function,$in_ENABLE_MULTI_VALUES)=@_;
&set_decode_function($in_SUB_decode_function)if(defined$in_SUB_decode_function);
$NL::CGI::DATA->{'DYNAMIC'}->{'ENABLE_MULTI_VALUES'}=1 if(defined$in_ENABLE_MULTI_VALUES&&$in_ENABLE_MULTI_VALUES==1);}sub set_decode_function{my($in_SUB_decode_function)=@_;
$NL::CGI::DATA->{'DYNAMIC'}->{'FUNC_decode'}=$in_SUB_decode_function if(defined$in_SUB_decode_function&&ref$in_SUB_decode_function eq 'CODE');}sub _decode_data{my($in_REF_SCALAR_data)=@_;
if(defined$NL::CGI::DATA->{'DYNAMIC'}->{'FUNC_decode'}&&defined$in_REF_SCALAR_data){&{$NL::CGI::DATA->{'DYNAMIC'}->{'FUNC_decode'}}($in_REF_SCALAR_data);}}sub get_input_from_GET{return&_get_input_GET((defined$_[0]&&$_[0]==0)?0:1);}sub get_input_from_POST{return&_get_input_POST((defined$_[0]&&$_[0]==0)?0:1);}sub get_input_from_POST_FILE{return{}if(!defined$_[0]||$_[0]eq '');return&_get_input_POST(0,$_[0]);}sub get_input{my$ref_HASH_GET=&_get_input_GET(1);
my$ref_HASH_POST=&_get_input_POST(1);
foreach(keys%{$ref_HASH_GET}){$ref_HASH_POST->{$_}=$ref_HASH_GET->{$_}if(!defined$ref_HASH_POST->{$_});}return$ref_HASH_POST;}sub _get_input_POST{my($in_USE_CACHE,$in_READ_filename)=@_;
$in_USE_CACHE=0 if(!defined$in_USE_CACHE);
$in_READ_filename='' if(!defined$in_READ_filename);
return$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_POST'}if($in_USE_CACHE&&defined$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_POST'});
my$ref_hash_PARAMS={};
my$tmp_buffer='';
my$PARSE_BUFFER=0;
my$boundary='';
if($in_READ_filename ne ''){if(-f$in_READ_filename){my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)=stat($in_READ_filename);
if($size>0&&open(FILE_IN,"<$in_READ_filename")){binmode FILE_IN;
seek(FILE_IN,0,0);
read(FILE_IN,$tmp_buffer,$size);
close(FILE_IN);
if($tmp_buffer=~/^(.*)$CRLF/){if(length($1)<=256){$boundary=$1;
$PARSE_BUFFER=1;}}}}}elsif(defined$ENV{'REQUEST_METHOD'}&&$ENV{'REQUEST_METHOD'}eq 'POST'&&defined$ENV{'CONTENT_LENGTH'}){if(defined$ENV{'CONTENT_TYPE'}&&$ENV{'CONTENT_TYPE'}=~m/^multipart\/form-data/){binmode(STDIN);
seek(STDIN,0,0);
read(STDIN,$tmp_buffer,$ENV{'CONTENT_LENGTH'});
($boundary)=$ENV{'CONTENT_TYPE'}=~/boundary=\"?([^\";,]+)\"?/;
$boundary='--'.$boundary;
$PARSE_BUFFER=1;}else{read(STDIN,$tmp_buffer,$ENV{'CONTENT_LENGTH'});
if($tmp_buffer!~/^[\s]{0,}$/){$ref_hash_PARAMS=&_get_input_GET(0,\$tmp_buffer);}}}if($PARSE_BUFFER){if(defined$boundary&&$boundary ne ''){$tmp_buffer=substr($tmp_buffer,length($boundary)+$CRLF_len,index($tmp_buffer,$boundary.'--'.$CRLF)-$CRLF_len-length($boundary));
for(split(/$boundary$CRLF/,$tmp_buffer)){$_=substr($_,0,length($_)-$CRLF_len);
my$pos=index($_,$CRLF.$CRLF);
my$header=substr($_,0,$pos);
my$value=substr($_,$pos+2*$CRLF_len);
my($name)=$header=~/ name="([^;]*)"/;
if(defined$name&&$name ne ''&&defined$value){if($header=~/filename=/){my($fname)=$header=~/ filename="([^;]*)"/;
if(defined$fname&&$fname ne ''){my($fCT)=$header=~/Content-Type: (.*)($CRLF|$)/;
&_add_param_file($ref_hash_PARAMS,\$name,\$fname,\$value,(defined$fCT&&$fCT!~/^[\s]{0,}$/)?$fCT:'');}}else{&_add_param($ref_hash_PARAMS,\$name,\$value);}}}}}if($in_USE_CACHE){$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_POST'}=$ref_hash_PARAMS;
my%return_HASH=%{$ref_hash_PARAMS};
return\%return_HASH;}else{return$ref_hash_PARAMS;}}sub _get_input_GET{my($in_USE_CACHE,$in_REF_val)=@_;
$in_USE_CACHE=0 if(!defined$in_USE_CACHE);
$in_REF_val=0 if(!defined$in_REF_val);
return$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_GET'}if($in_USE_CACHE&&defined$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_GET'});
my$ref_hash_PARAMS={};
my$tmp_buffer='';
if($in_REF_val){$tmp_buffer=${$in_REF_val};}elsif(defined$ENV{'QUERY_STRING'}&&$ENV{'QUERY_STRING'}ne ''){$tmp_buffer=$ENV{'QUERY_STRING'};}if($tmp_buffer ne ''){$tmp_buffer=~s/&(?!amp;)/&amp;/g;
for(split(/&amp;/,$tmp_buffer)){if($_=~/^([^\=]+)\=(.*)$/){my($name,$value)=($1,$2);
if(defined$name&&$name ne ''&&defined$value){for($name,$value){tr/+/ /;
s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;}&_add_param($ref_hash_PARAMS,\$name,\$value);}}}}if($in_USE_CACHE){$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_GET'}=$ref_hash_PARAMS;
my%return_HASH=%{$ref_hash_PARAMS};
return\%return_HASH;}else{return$ref_hash_PARAMS;}}sub _add_param{my($in_REF_HASH,$in_REF_name,$in_REF_value)=@_;
if(defined$in_REF_name&&${$in_REF_name}ne ''&&defined$in_REF_value){&_decode_data($in_REF_name);
&_decode_data($in_REF_value);
if(!defined$in_REF_HASH->{${$in_REF_name}}){$in_REF_HASH->{${$in_REF_name}}=${$in_REF_value};}else{if(!$NL::CGI::DATA->{'DYNAMIC'}->{'ENABLE_MULTI_VALUES'}){return;}if(ref$in_REF_HASH->{${$in_REF_name}}){push(@{$in_REF_HASH->{${$in_REF_name}}},${$in_REF_value});}else{$in_REF_HASH->{${$in_REF_name}}=[$in_REF_HASH->{${$in_REF_name}},${$in_REF_value}];}}}}sub _add_param_file{my($in_REF_HASH,$in_REF_name,$in_REF_fname,$in_REF_fvalue,$in_ContentType)=@_;
$in_ContentType='' if(!defined$in_ContentType);
if(defined$in_REF_name&&${$in_REF_name}ne ''&&defined$in_REF_fname&&${$in_REF_fname}ne ''&&defined$in_REF_fvalue){&_decode_data($in_REF_name);
&_decode_data($in_REF_fname);
my$file_container={'filename'=>${$in_REF_fname},'data'=>${$in_REF_fvalue}};
$file_container->{'content-type'}=$in_ContentType if($in_ContentType ne '');
if(!defined$in_REF_HASH->{${$in_REF_name}}){$in_REF_HASH->{${$in_REF_name}}=$file_container;}else{if(!$NL::CGI::DATA->{'DYNAMIC'}->{'ENABLE_MULTI_VALUES'}){return;}if(ref$in_REF_HASH->{${$in_REF_name}}eq 'ARRAY'){push(@{$in_REF_HASH->{${$in_REF_name}}},$file_container);}else{$in_REF_HASH->{${$in_REF_name}}=[$in_REF_HASH->{${$in_REF_name}},$file_container];}}}}package NL::Dir;
use strict;
use Cwd ('getcwd','cwd');
$NL::Dir::IS_OS_WIN32=($^O eq 'MSWin32')?1:0;
sub get_current_dir{my$dir=getcwd();
$dir=cwd()if(!defined$dir);
return$dir;}sub get_dir_splitters{my@arr_splitters=('/',[]);
if($^O eq 'MacOS'){$arr_splitters[0]=':';}elsif($NL::Dir::IS_OS_WIN32){$arr_splitters[0]='/';
$arr_splitters[1]=['\\'];}return@arr_splitters;}sub get_dir_splitter{my@arr_splitters=&get_dir_splitters();return$arr_splitters[0];}sub change_dir{return chdir($_[0]);}sub list{my($in_dir,$in_sort)=@_;
$in_dir='' if(!defined$in_dir);
$in_sort=0 if(!defined$in_sort);
my$ref_arr_dir_listing=[];
return(-1,$ref_arr_dir_listing)if($in_dir eq '');
opendir(DIR,$in_dir)or return(0,$ref_arr_dir_listing);
@{$ref_arr_dir_listing}=grep (!/^\.+$/,readdir(DIR));
closedir(DIR);
if($in_sort==1){@{$ref_arr_dir_listing}=sort{lc($a)cmp lc($b)}@{$ref_arr_dir_listing};}elsif($in_sort==2){@{$ref_arr_dir_listing}=sort{lc($b)cmp lc($a)}@{$ref_arr_dir_listing};}return(1,$ref_arr_dir_listing);}sub check_in{my($in_value)=@_;
my$result='';
if(defined$in_value){$result=$in_value;
if($NL::Dir::IS_OS_WIN32){if($result=~/^"([^"]{0,})"?([^"]{0,})$/){$result=(defined$1?$1:'').(defined$2?$2:'');}elsif($result=~/^([^"]{0,})$/){$result=(defined$1?$1:'');}}else{$result=~s/\\([^\\]|$)/$1/g;}}return$result;}sub check_out{my($in_value)=@_;
my$result='';
if(defined$in_value){$result=$in_value;
if($NL::Dir::IS_OS_WIN32){if($result=~/^"/&&$result!~/"$/){$result.='"';}elsif($result=~/[ \/\t]/){$result='"'.$result.'"';}}else{$result=~s/([ \\])/\\$1/g;}}return$result;}sub remove_old_files{my($in_DIR,$in_SETTINGS)=@_;
$in_DIR='' if(!defined$in_DIR);
$in_SETTINGS={}if(!$in_SETTINGS);
$in_SETTINGS->{'SECONDS_OLD'}=3600*24 if(!defined$in_SETTINGS->{'SECONDS_OLD'}||$in_SETTINGS->{'SECONDS_OLD'}<=0);
$in_SETTINGS->{'SKIP_FILES'}=[]if(!defined$in_SETTINGS->{'SKIP_FILES'});
if($in_DIR ne ''&&-d$in_DIR){my@arr_listing;
if(opendir(DIR,$in_DIR)){@arr_listing=grep(!/^\.{1,2}$/,readdir(DIR));
closedir(DIR);}if(scalar@arr_listing>0){my$dir_splitter=&get_dir_splitter();
my$dir=($in_DIR=~/${dir_splitter}$/)?$in_DIR:$in_DIR.$dir_splitter;
my$time=time();
foreach(@arr_listing){my$val=$_;
foreach(@{$in_SETTINGS->{'SKIP_FILES'}}){if($_ eq$val){$val='';last;}}if($val eq ''){next;}my$file=$dir.$val;
if(-f$file){my@arr_stat=stat($file);
if(defined$arr_stat[9]){if($time-$arr_stat[9]>=$in_SETTINGS->{'SECONDS_OLD'}){unlink$file;}}}}return 1;}}return 0;}package NL::String;
use strict;
sub re_replace{my($in_val,$ref_arr_REPLACE)=@_;
my$tmp_ref=ref$in_val;
my$ref_to_value;
if($tmp_ref){if($tmp_ref eq 'SCALAR'){$ref_to_value=$in_val;}else{return 0;}}else{$ref_to_value=\$in_val;}foreach my $arr_element(@{$ref_arr_REPLACE}){foreach(keys%{$arr_element}){${$ref_to_value}=~s/$_/$arr_element->{$_}/g;}}if(!ref$ref_to_value){return 1;}else{return${$ref_to_value};}}sub str_trim{return&re_replace($_[0],[{qr/^\s+/=>'',qr/\s+$/=>''}]);}sub str_JS_value{my($in_val)=@_;
return&re_replace($in_val,[{qr/\\/=>'\\\\'},{qr/'/=>'\\\'',qr/"/=>'\\"'},{qr/\t/=>'\\t',qr/\n/=>'\\n',qr/\r/=>'\\r'}]);}sub str_HTTP_REQUEST_value{my($in_val)=@_;
my$tmp_ref=ref$in_val;
my$ref_to_value;
if($tmp_ref){if($tmp_ref eq 'SCALAR'){$ref_to_value=$in_val;}else{return 0;}}else{$ref_to_value=\$in_val;}${$ref_to_value}=~s/(.)/sprintf("%"."%"."%x", ord($1))/eg;
if(!ref$ref_to_value){return 1;}else{return${$ref_to_value};}}sub str_HTML{return&str_HTML_full(@_);}sub str_HTML_full{my($in_val)=@_;
return&re_replace($in_val,[{qr/&/=>'&amp;'},{qr/</=>'&lt;',qr/>/=>'&gt;'},{qr/"/=>'&quot;'},{qr/ /=>'&nbsp;',qr/\t/=>'&nbsp;' x 4},{qr/\n/=>'<br />'}]);}sub str_HTML_value{my($in_val)=@_;
return&re_replace($in_val,[{qr/&/=>'&amp;'},{qr/</=>'&lt;',qr/>/=>'&gt;'},{qr/"/=>'&quot;'}]);}sub get_left{my($in_val,$in_len,$in_add_dottes)=@_;
$in_add_dottes=0 if(!defined$in_add_dottes);
my$len_needed=$in_len;
my$add_dottes=0;
if($in_add_dottes&&$in_len>=3){$len_needed=$in_len-3;
$add_dottes=1;}my$str_len=length($in_val);
if($str_len>$len_needed){$in_val=substr($in_val,0,$len_needed).(($add_dottes)?'...':'');}return$in_val;}sub get_right{my($in_val,$in_len,$in_add_dottes)=@_;
$in_add_dottes=0 if(!defined$in_add_dottes);
my$len_needed=$in_len;
my$add_dottes=0;
my$str_len=length($in_val);
if($str_len>$len_needed){if($in_add_dottes&&$in_len>=3){$len_needed=$in_len-3;
$add_dottes=1;}$in_val=(($add_dottes)?'...':'').substr($in_val,$str_len-$len_needed);}return$in_val;}sub get_str_of_bytes{my($in_bytes)=@_;
my@arr_SIZE=('Kb','MB','GB');
my$arr_SIZE_length=scalar@arr_SIZE;
my$size=$in_bytes;
my$size_i=-1;
for(my$i=0;$i<$arr_SIZE_length;$i++){my$new_size=$size/1024;
if($new_size>=1){$size=$new_size;$size_i=$i;}else{last;}}$size=sprintf("%.2f",$size);
$size=~s/(\.[^0]{0,})0+$/$1/;
$size=~s/\.$//;
return$size.' '.($size_i>=0?$arr_SIZE[$size_i]:'byte(s)');}sub JSON_to_HASH{my($in_value)=@_;
if(defined$in_value&&$in_value ne ''){$in_value=~s/("(\\"|[^"])+"|([^ ,"\n\t])+)[ \n\t]{0,}:[ \n\t]{0,}("(\\"|[^"])+"|([^ ,\n\t])+)/$1 => $4/g;
my$result_HASH={};
eval '$result_HASH = '.$in_value.';';
if($@){return{'ID'=>0,'HASH'=>{},'ERROR'=>$@};}else{return{'ID'=>1,'HASH'=>$result_HASH};}}return{'ID'=>1,'HASH'=>{}};}sub str_to_line{my($in_val)=@_;
return '' if(!defined$in_val);
my$ref_arr_RE=[{qr/\r/=>''},{qr/\n+/=>' '},{qr/\t+/=>' '},{qr/ {2,}/=>' '}];
return&re_replace($in_val,$ref_arr_RE);}sub str_unescape{my($in_val)=@_;
return '' if(!defined$in_val);
my$tmp_ref=ref$in_val;
my$ref_to_value;
if($tmp_ref){if($tmp_ref eq 'SCALAR'){$ref_to_value=$in_val;}else{return 0;}}else{$ref_to_value=\$in_val;}my$len=length(${$ref_to_value});
for(my$i=0;$i<$len;$i++){if(substr(${$ref_to_value},$i,1)eq"\\"){if($i+1<$len){my$next=substr(${$ref_to_value},$i+1,1);
if($next eq 'n'){substr(${$ref_to_value},$i,2)="\n";}elsif($next eq 't'){substr(${$ref_to_value},$i,2)="\t";}elsif($next eq 'r'){substr(${$ref_to_value},$i,2)="\r";}elsif($next eq"\\"){substr(${$ref_to_value},$i,2)="\\";}else{substr(${$ref_to_value},$i,1)='';}}else{substr(${$ref_to_value},$i,1)='';}$len--;}}if(!ref$ref_to_value){return 1;}else{return${$ref_to_value};}}sub str_escape{my($in_val,$in_type)=@_;
return '' if(!defined$in_val);
$in_type='PERL' if(!defined$in_type||$in_type eq '');
my$ref_arr_RE=[{qr/\\/=>'\\\\'},{qr/"/=>'\\"'},{qr/\t/=>'\\t'},{qr/\n/=>'\\n'},{qr/\r/=>'\\r'}];
push@{$ref_arr_RE},{qr/\@/=>'\\@'},{qr/\$/=>'\\$'}if($in_type eq 'PERL');
return&re_replace($in_val,$ref_arr_RE);}sub str_escape_JSON{return&str_escape($_[0],'JSON');}sub VAR_to_PERL{return&_VAR_to_STRING($_[0],'PERL',(defined$_[1])?$_[1]:{});}sub VAR_to_JSON{return&_VAR_to_STRING($_[0],'JSON',(defined$_[1])?$_[1]:{});}sub _VAR_to_STRING{my($in_DATA,$in_type,$in_SETTINGS,$in_recursion_level)=@_;
$in_DATA='' if(!defined$in_DATA);
$in_type='PERL' if(!defined$in_type||$in_type eq '');
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_recursion_level=0 if(!defined$in_recursion_level);
my$use_spaces=(defined$in_SETTINGS->{'SPACES'}&&$in_SETTINGS->{'SPACES'})?1:0;
my$tabs_string='';
$tabs_string.="\t" x$in_recursion_level if($use_spaces);
my$elements={'hash_splitter'=>'=>'};
my$ref_SUB_escape=\&str_escape;
if($in_type eq 'JSON'){$elements->{'hash_splitter'}=':';
$ref_SUB_escape=\&str_escape_JSON;}my$str_RESULT='';
my$type=ref($in_DATA);
if($type){if($type eq 'HASH'){foreach((defined$in_SETTINGS->{'SORT'}&&$in_SETTINGS->{'SORT'})?sort keys%{$in_DATA}:keys%{$in_DATA}){$str_RESULT.=','.(($use_spaces)?"\n":'')if($str_RESULT ne '');
$str_RESULT.=(($use_spaces)?$tabs_string."\t":'').'"'.(&{$ref_SUB_escape}($_)).'"'.(($use_spaces&&$in_type ne 'JSON')?' ':'').$elements->{'hash_splitter'}.(($use_spaces)?' ':'').(&_VAR_to_STRING($in_DATA->{$_},$in_type,$in_SETTINGS,$in_recursion_level+1));}return '{'.(($use_spaces)?"\n":'').$str_RESULT.(($use_spaces)?"\n".$tabs_string:'').'}';}elsif($type eq 'ARRAY'){foreach(@{$in_DATA}){$str_RESULT.=','.(($use_spaces)?"\n":'')if($str_RESULT ne '');
$str_RESULT.=(($use_spaces)?$tabs_string."\t":'').&_VAR_to_STRING($_,$in_type,$in_SETTINGS,$in_recursion_level+1);}return '['.(($use_spaces)?"\n":'').$str_RESULT.(($use_spaces)?"\n".$tabs_string:'').']';}}else{if($in_DATA=~/^(\d+|\d+\.\d+)$/&&$in_DATA!~/(^0\d|00$)/){return$in_DATA;}else{return '"'.(&{$ref_SUB_escape}($in_DATA)).'"';}}}sub fix_width{my($in_DATA,$in_LEN)=@_;
$in_LEN=50 if(!defined$in_LEN||$in_LEN<0);
my$re_SPACES=' \t\n';
my$i=0;
$in_DATA=~s/\r//g;
my$LEN=length($in_DATA);
while($i<$LEN){my$new_pos=$i+$in_LEN;
if($new_pos<$LEN){my$char=substr($in_DATA,$new_pos,1);
if($char=~/^[${re_SPACES}]$/){substr($in_DATA,$new_pos,1,"\n");
$new_pos++;}else{my$sub_str=substr($in_DATA,$i,$in_LEN);
if($sub_str=~/[${re_SPACES}][^${re_SPACES}]{0,}$/){my$pos=$-[$#-];
substr($in_DATA,$i+$pos,1,"\n");
$new_pos=$i+$pos+1;}else{substr($in_DATA,$new_pos,0,"\n");
$new_pos++;}}}$i=$new_pos;}return$in_DATA;}package NL::File;
use strict;
sub get_size{my($file)=@_;
if(defined$file&&$file ne ''){if(-f$file){my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)=stat($file);
if(defined$size&&$size>=0){return$size;}else{return-3;}}else{return-2;}}else{return-1;}}sub is_exists{my($in_file)=@_;
if(defined$in_file&&$in_file ne ''&&-f$in_file){return 1;}return 0;}package NL::File::Lock;
use strict;
our$VERSION='0.3';
sub LOCK_SH(){1}sub LOCK_EX(){2}sub LOCK_NB(){4}sub LOCK_UN(){8}$NL::File::Lock::OS_SETTINGS={'IS_SOLARIS'=>0,'USE_FCNTL'=>0,'FCNTL_ERROR'=>''};
if($^O=~/^(solaris|sunos)$/i){$NL::File::Lock::OS_SETTINGS->{'IS_SOLARIS'}=1;
$NL::File::Lock::OS_SETTINGS->{'USE_FCNTL'}=1;
eval{require Fcntl;};
if($@){$NL::File::Lock::OS_SETTINGS->{'USE_FCNTL'}=0;
$NL::File::Lock::OS_SETTINGS->{'FCNTL_ERROR'}=$@;}else{Fcntl->import();}}$NL::File::Lock::DATA={'SETTINGS'=>{'SECONDS_TO_REMOVE_OLD_LOCKS'=>3600*5,'LOCK_FILE_POSTFIX'=>'.lck','dir_for_locks'=>'','dir_splitter'=>'/','dir_splitters_extra'=>[]},'LOCKED_FILES'=>{}};
sub _path_get_file{my($str)=@_;
foreach my $spl($NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitter'},@{$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitters_extra'}}){my$splitter=quotemeta($spl);
$str=~s/^.*$splitter([^$splitter]{0,})$/$1/;}return$str;}sub _path_dir_chomp{my($ref_str)=@_;
foreach my $spl($NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitter'},@{$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitters_extra'}}){my$splitter=quotemeta($spl);
${$ref_str}=~s/[$splitter]{1,}$//;}}sub _make_lock_file_name{my($file_name)=@_;
if($NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'}ne ''){my$fn=&_path_get_file($file_name);
if($fn ne ''){return$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'}.$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitter'}.$fn.$NL::File::Lock::DATA->{'SETTINGS'}->{'LOCK_FILE_POSTFIX'};}}return$file_name.$NL::File::Lock::DATA->{'SETTINGS'}->{'LOCK_FILE_POSTFIX'};}sub init{my($dir_for_locks,$in_SETTINGS)=@_;
$in_SETTINGS={}if(!$in_SETTINGS);
if($^O eq 'MacOS'){$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitter'}=':';}elsif($^O eq 'MSWin32'){$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitter'}='/';
$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitters_extra'}=['\\'];}if(defined$dir_for_locks&&$dir_for_locks ne ''){&_path_dir_chomp(\$dir_for_locks);
if($dir_for_locks ne ''&&-d$dir_for_locks){$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'}=$dir_for_locks;
if(defined$in_SETTINGS->{'REMOVE_OLD'}&&$in_SETTINGS->{'REMOVE_OLD'}){my@arr_listing;
if(opendir(DIR,$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'})){my$pf_QM=quotemeta($NL::File::Lock::DATA->{'SETTINGS'}->{'LOCK_FILE_POSTFIX'});
@arr_listing=grep(/${pf_QM}$/,grep(!/^\.{1,2}$/,readdir(DIR)));
closedir(DIR);}my$splitter=$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_splitter'};
my$dir=($NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'}=~/$splitter$/)?$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'}:$NL::File::Lock::DATA->{'SETTINGS'}->{'dir_for_locks'}.$splitter;
my$time=time();
foreach(@arr_listing){my$file=$dir.$_;
if(-f$file){my@arr_stat=stat($file);
if(defined$arr_stat[9]){unlink$file if($time-$arr_stat[9]>=$NL::File::Lock::DATA->{'SETTINGS'}->{'SECONDS_TO_REMOVE_OLD_LOCKS'});}}}}return 1;}}return 0;}sub lock_read{my($file_name,$in_ref_hash_EXT)=@_;return&lf_lock($file_name,&LOCK_SH(),defined$in_ref_hash_EXT?$in_ref_hash_EXT:{});}sub lock_write{my($file_name,$in_ref_hash_EXT)=@_;return&lf_lock($file_name,&LOCK_EX(),defined$in_ref_hash_EXT?$in_ref_hash_EXT:{});}sub lf_lock{my($file_name,$lock_type,$in_ref_hash_EXT)=@_;
$lock_type=&LOCK_EX()if(!defined$lock_type||$lock_type<=0);
$in_ref_hash_EXT={}if(!defined$in_ref_hash_EXT||ref$in_ref_hash_EXT ne 'HASH');
my$lock_file_name='';
my($time_stop,$time_sleep)=(0,0);
if(defined$in_ref_hash_EXT->{'timeout'}){$time_sleep=(defined$in_ref_hash_EXT->{'time_sleep'}&&$in_ref_hash_EXT->{'time_sleep'}>0)?$in_ref_hash_EXT->{'time_sleep'}:0;
$time_stop=time()+$in_ref_hash_EXT->{'timeout'};}if(defined$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}){if($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'IS_LOCKED'}){return 2;}else{if(&_lf_lock_MAKE_LOCK($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'lock_handle'},$lock_type,$time_stop,$time_sleep)){$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'IS_LOCKED'}=1;
return 1;}else{return 0;}}}else{$lock_file_name=&_make_lock_file_name($file_name);}my$is_locked=0;
do{my$FILE_OPENED=0;
if($NL::File::Lock::OS_SETTINGS->{'USE_FCNTL'}){eval '$FILE_OPENED = sysopen(LFH, $lock_file_name, O_RDWR|O_CREAT)';}else{$FILE_OPENED=open(LFH,">>$lock_file_name");}if($FILE_OPENED){if(&_lf_lock_MAKE_LOCK(\*LFH,$lock_type,$time_stop,$time_sleep)){$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}={'IS_LOCKED'=>1,'lock_file'=>$lock_file_name,'lock_handle'=>\*LFH};
return 1;}else{close(LFH);
return 0;}}else{if($time_sleep>0){select(undef,undef,undef,$time_sleep);}}}while(!$is_locked&&time()<$time_stop);
return 0;}sub _lf_lock_MAKE_LOCK{my($lock_file_handle,$lock_type,$time_stop,$time_sleep)=@_;
$lock_type=&LOCK_EX()if($NL::File::Lock::OS_SETTINGS->{'IS_SOLARIS'}&&!$NL::File::Lock::OS_SETTINGS->{'USE_FCNTL'}&&$lock_type==&LOCK_SH());
do{if(flock($lock_file_handle,$lock_type|&LOCK_NB())){return 1;}else{if($time_sleep>0){select(undef,undef,undef,$time_sleep);}}}while(time()<$time_stop);
return 0;}sub unlock{my($file_name,$not_unlink)=@_;
$not_unlink=0 if(!defined$not_unlink);
if(defined$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}){if($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'IS_LOCKED'}){flock($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'lock_handle'},&LOCK_UN());}close$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'lock_handle'};
unlink$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'lock_file'}if(!$not_unlink);
delete$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name};
return 1;}return 0;}sub unlock_not_unlink{my($file_name)=@_;
return&unlock($file_name,1);}sub unlock_not_close{my($file_name)=@_;
if(defined$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}){if($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'IS_LOCKED'}){if($]<5.004){my$old_fh=select($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'lock_handle'});
local$|=1;
local$\='';
print '';
select($old_fh);}flock($NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'lock_handle'},&LOCK_UN());
$NL::File::Lock::DATA->{'LOCKED_FILES'}->{$file_name}->{'status'}='unlocked';
return 1;}}return 0;}sub END{foreach(keys%{$NL::File::Lock::DATA->{'LOCKED_FILES'}}){&unlock($_);}}sub flock_read{return&_flock($_[0],&LOCK_SH());}sub flock_write{return&_flock($_[0],&LOCK_EX());}sub _flock{my($file_handle,$lock_type)=@_;
$lock_type=&LOCK_EX()if(!defined$lock_type||$lock_type<=0);
return flock($file_handle,$lock_type);}sub unflock{return flock($_[0],&LOCK_UN());}sub TEST{my$test_in=shift||0;
if($test_in==0){if(&NL::File::Lock::lock_write('file',{'timeout'=>10,'time_sleep'=>0.1})){print"+Locked EX (write)...\n";
sleep(5);
&NL::File::Lock::unlock_not_unlink('file');
print"-UnLocked for some time...\n";
sleep(5);
if(&NL::File::Lock::lock_write('file',{'timeout'=>10,'time_sleep'=>0.1})){print"+Locked EX (write)...\n";
sleep(5);
&NL::File::Lock::unlock('file');
print"-UnLocked forever...\n";
sleep(5);}else{print"Unable to lock EX (write) again...\n";}}else{print"Unable to lock EX (write)...\n";}}elsif($test_in==1){if(&NL::File::Lock::lock_write('file',{'timeout'=>10,'time_sleep'=>0.1})){print"+Locked EX (write)...\n";
sleep(2);
&NL::File::Lock::unlock('file');
print"-UnLocked forever...\n";}else{print"Unable to lock EX (write)...\n";}}elsif($test_in==2){if(&NL::File::Lock::lock_read('file',{'timeout'=>10,'time_sleep'=>0.1})){print"+Locked SH (read)...\n";
sleep(5);
&NL::File::Lock::unlock_not_close('file');
print"-UnLocked for some time...\n";
sleep(5);
if(&NL::File::Lock::lock_read('file',{'timeout'=>10,'time_sleep'=>0.1})){print"+Locked SH (read)...\n";
sleep(5);
&NL::File::Lock::unlock('file');
print"-UnLocked forever...\n";
sleep(5);}else{print"Unable to lock SH (read) agian...\n";}}else{print"Unable to lock SH (read)...\n";}}}package NL::AJAX;
use strict;
$NL::AJAX::DATA={'DYNAMIC'=>{}};
sub init{my($in_REF_HASH_params)=@_;
return 0 if(!defined$in_REF_HASH_params||!$in_REF_HASH_params);
if(defined$in_REF_HASH_params->{'JsHttpRequest'}&&$in_REF_HASH_params->{'JsHttpRequest'}=~/^(\d+)\-(.*)$/){$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}={'JsHttpRequest_id'=>$1,'JsHttpRequest_loader'=>$2};
return 1;}return 0;}sub get_request_id{return(defined$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}&&defined$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'})?$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}:0;}sub show_response{my($in_REF_HASH_response_params,$in_SCALAR_response_text,$in_REF_ARR_headers)=@_;
return 0 if(!defined$in_REF_HASH_response_params||!$in_REF_HASH_response_params);
$in_SCALAR_response_text='' if(!defined$in_SCALAR_response_text);
$in_REF_ARR_headers=[]if(!defined$in_SCALAR_response_text);
my($js_request_id,$js_request_loader)=(0,'');
if(defined$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}){($js_request_id,$js_request_loader)=($NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'},$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_loader'});}else{return 0;}my$resultHASH={'id'=>$js_request_id,'text'=>$in_SCALAR_response_text,'js'=>$in_REF_HASH_response_params};
my$str_output=&NL::String::VAR_to_JSON($resultHASH);
if($js_request_loader ne 'xml'){$str_output=($js_request_loader eq 'form'?'top && top.JsHttpRequestGlobal && top.JsHttpRequestGlobal':'JsHttpRequest').'.dataReady('.$str_output.");\n";
if($js_request_loader eq"form"){$str_output='<script type="text/javascript" language="JavaScript"><!--'."\n$str_output".'//--></script>';}}foreach(@{$in_REF_ARR_headers}){print$_."\r\n" if($_!~/^\s{0,}$/);}print"Content-type: text/html; charset=utf-8\r\n\r\n";
print$str_output;
return 1;}package NL::AJAX::Upload;
use strict;
$NL::AJAX::Upload::CGI_PM_LOADED=0;
$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK=0;
$NL::Upload::DATA={'CONST'=>{},'DYNAMIC'=>{'POST_MAX'=>1024*(1024*1024),'DIR_TEMP'=>'','UPLOAD'=>{'SID'=>'','METHOD'=>'','STATUS'=>{'file_name'=>'','file_handle'=>undef,'file_locked'=>0,'file_locked_time'=>0,'INFO'=>{'status'=>'UPLOADING','file_current_name'=>'','file_current_number'=>0,'size_current'=>0,'size_total'=>0,'time_start'=>0}},'FILES'=>{},'TEMP'=>{}}},'ACTIVE_OBJECT'=>{}};
sub init{my($in_SETTINGS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
$NL::Upload::DATA->{'DYNAMIC'}->{'POST_MAX'}=$in_SETTINGS->{'POST_MAX'}if(defined$in_SETTINGS->{'POST_MAX'}&&$in_SETTINGS->{'POST_MAX'}>0);
$NL::Upload::DATA->{'DYNAMIC'}->{'DIR_TEMP'}=$in_SETTINGS->{'DIR_TEMP'}if(defined$in_SETTINGS->{'DIR_TEMP'}&&$in_SETTINGS->{'DIR_TEMP'}ne '');
my$INIT_RESULT={'ID'=>1,'ERROR_MSG'=>''};
eval{require CGI;};
if($@){$INIT_RESULT={'ID'=>0,'ERROR_MSG'=>"Unable to load module 'CGI.pm', that module is needed for uploading:\n$@"};}else{$NL::AJAX::Upload::CGI_PM_LOADED=1;
$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK=$CGI::VERSION>=3.03?1:0;
$CGI::POST_MAX=$NL::Upload::DATA->{'DYNAMIC'}->{'POST_MAX'};}return$INIT_RESULT;}sub start_upload{my($in_SETTINGS,$in_PARAMETERS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_PARAMETERS={}if(!defined$in_PARAMETERS);
my$UPLOAD_RESULT={'ID'=>0,'UPLOADS'=>{},'ERROR_MSG'=>''};
my$DIR_TEMP=$NL::Upload::DATA->{'DYNAMIC'}->{'DIR_TEMP'};
my$POST_MAX=$NL::Upload::DATA->{'DYNAMIC'}->{'POST_MAX'};
if(defined$in_SETTINGS->{'DIR_TEMP'}&&$in_SETTINGS->{'DIR_TEMP'}ne ''){$DIR_TEMP=$in_SETTINGS->{'DIR_TEMP'};}if(defined$in_SETTINGS->{'POST_MAX'}&&$in_SETTINGS->{'POST_MAX'}>0){$POST_MAX=$in_SETTINGS->{'POST_MAX'};
$CGI::POST_MAX=$POST_MAX if($NL::AJAX::Upload::CGI_PM_LOADED);}if(!defined$in_SETTINGS->{'SID'}||$in_SETTINGS->{'SID'}eq ''){$UPLOAD_RESULT->{'ERROR_MSG'}='"SID" is not specified, unable to start uploading';}elsif($DIR_TEMP ne ''&&!-d$DIR_TEMP){$UPLOAD_RESULT->{'ERROR_MSG'}='TEMP directory "'.&NL::String::get_right($DIR_TEMP,40,1).'" not found';}elsif(!defined$ENV{'CONTENT_LENGTH'}){$UPLOAD_RESULT->{'ERROR_MSG'}='"CONTENT_LENGTH" is not defined';}elsif($ENV{'CONTENT_LENGTH'}>$POST_MAX){$UPLOAD_RESULT->{'ERROR_MSG'}="You tried to send ".&NL::String::get_str_of_bytes($ENV{'CONTENT_LENGTH'}).", but the current limit is ".&NL::String::get_str_of_bytes($POST_MAX).".\nPlease choose a smaller file(s).";}if($UPLOAD_RESULT->{'ERROR_MSG'}ne ''){return$UPLOAD_RESULT;}if($DIR_TEMP ne ''){my$dir_splitter=&NL::Dir::get_dir_splitter();
$DIR_TEMP.=$dir_splitter if($DIR_TEMP!~/${dir_splitter}$/);}my$DATA_CONTAINER={};
&NL::Utils::hash_clone($DATA_CONTAINER,$NL::Upload::DATA->{'DYNAMIC'});
$DATA_CONTAINER->{'POST_MAX'}=$POST_MAX;
$DATA_CONTAINER->{'DIR_TEMP'}=$DIR_TEMP;
$DATA_CONTAINER->{'UPLOAD'}->{'SID'}=$in_SETTINGS->{'SID'};
$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'time_start'}=time();
$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_total'}=$ENV{'CONTENT_LENGTH'};
$DATA_CONTAINER->{'UPLOAD'}->{'TEMP'}->{'STATUS_UPDATE_SIZE_INTERVAL'}=$ENV{'CONTENT_LENGTH'}*0.05;
$NL::Upload::DATA->{'ACTIVE_OBJECT'}=$DATA_CONTAINER;
my$OLD_STDIN=undef;
if($NL::AJAX::Upload::CGI_PM_LOADED){my$CGI_QUERY;
if($DIR_TEMP ne ''){if(defined$TempFile::TMPDIRECTORY&&$TempFile::TMPDIRECTORY){$TempFile::TMPDIRECTORY=$DIR_TEMP;}elsif(defined$CGITempFile::TMPDIRECTORY&&$CGITempFile::TMPDIRECTORY){$CGITempFile::TMPDIRECTORY=$DIR_TEMP;}}if($NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK){$DATA_CONTAINER->{'UPLOAD'}->{'METHOD'}='STATUS_FILE';
$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'file_name'}=$DIR_TEMP.&status_filename_make($in_SETTINGS->{'SID'});
$CGI_QUERY=CGI->new(\&NL::AJAX::Upload::CGI_hook,{'DATA_CONTAINER'=>$DATA_CONTAINER,'FUNC_SAVE'=>\&status_save});
&status_save($DATA_CONTAINER,1);
sleep(3);
$UPLOAD_RESULT->{'UPLOADS'}=&CGI_process_uploads($CGI_QUERY,$in_PARAMETERS);
$UPLOAD_RESULT->{'INFO'}=&make_upload_info($DATA_CONTAINER,$in_PARAMETERS);
$UPLOAD_RESULT->{'ID'}=1;
return$UPLOAD_RESULT;
&status_close($DATA_CONTAINER);}else{$DATA_CONTAINER->{'UPLOAD'}->{'METHOD'}='POST_FILE';
$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'file_name'}=$DIR_TEMP.&status_filename_make_RAW($DATA_CONTAINER->{'UPLOAD'}->{'SID'},$ENV{'CONTENT_LENGTH'},$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'time_start'});
my$MANUAL_HOOK_RESULT=&CGI_hook_manual($DATA_CONTAINER);
if($MANUAL_HOOK_RESULT->{'ID'}){my$file_RAW_POST=$MANUAL_HOOK_RESULT->{'FILE_NAME'};
if(!&NL::File::Lock::lock_read($file_RAW_POST,{'timeout'=>10,'time_sleep'=>0.1})){$UPLOAD_RESULT->{'ERROR_MSG'}="Can't lock RAW_POST_DATA file ".&NL::String::get_right($file_RAW_POST,40,1)." for reading";
return$UPLOAD_RESULT;}open(OLDIN,"<&STDIN")or return{'ID'=>0,'UPLOADS'=>{},'ERROR_MSG'=>"Can't save original STDIN handle: $!"};
open(STDIN,"<$file_RAW_POST")or return{'ID'=>0,'UPLOADS'=>{},'ERROR_MSG'=>"Can't open RAW_POST_DATA file ".&NL::String::get_right($file_RAW_POST,40,1)." on STDIN: $!"};
seek(STDIN,0,0);
$CGI_QUERY=new CGI();
$UPLOAD_RESULT->{'UPLOADS'}=&CGI_process_uploads($CGI_QUERY,$in_PARAMETERS);
$UPLOAD_RESULT->{'INFO'}=&make_upload_info($DATA_CONTAINER,$in_PARAMETERS);
$UPLOAD_RESULT->{'ID'}=1;
close(STDIN);
open(STDIN,"<&OLDIN")or return{'ID'=>0,'UPLOADS'=>{},'ERROR_MSG'=>"Can't open original STDIN handle: $!"};
close(OLDIN);
unlink($file_RAW_POST);
&NL::File::Lock::unlock($file_RAW_POST);}else{$UPLOAD_RESULT->{'ERROR_MSG'}=$MANUAL_HOOK_RESULT->{'ERROR_MSG'};}}}else{$UPLOAD_RESULT->{'ERROR_MSG'}="Module 'CGI.pm' is not loaded";
return$UPLOAD_RESULT;
my$MANUAL_HOOK_RESULT=&CGI_hook_manual($DATA_CONTAINER);
if($MANUAL_HOOK_RESULT->{'ID'}){my$file_RAW_POST=$MANUAL_HOOK_RESULT->{'FILE_NAME'};
if(!&NL::File::Lock::lock_read($file_RAW_POST,{'timeout'=>10,'time_sleep'=>0.1})){return{'ID'=>0,'ERROR_MSG'=>"Can't lock RAW_POST_DATA file ".&NL::String::get_right($file_RAW_POST,40,1)." for reading"};}unlink($file_RAW_POST);
&NL::File::Lock::unlock($file_RAW_POST);}else{$UPLOAD_RESULT->{'ERROR_MSG'}=$MANUAL_HOOK_RESULT->{'ERROR_MSG'};}}return$UPLOAD_RESULT;}sub CGI_hook{my($filename,$buffer,$bytes_read,$ref_DATA)=@_;
if(defined$filename&&$filename ne ''&&defined$ref_DATA&&defined$ref_DATA->{'DATA_CONTAINER'}&&defined$ref_DATA->{'FUNC_SAVE'}){if(defined$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}&&defined$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}){my$in_FILENAME=&CGI_process_uploads_GET_FILE_NAME($filename);
if(!defined$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{$in_FILENAME}||$bytes_read>$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{$in_FILENAME}){$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{$in_FILENAME}=$bytes_read;
$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_name'}=$in_FILENAME;
$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_number'}=0;
$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'}=0;
map{$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'}+=$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{$_};
$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_number'}++;}(keys%{$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}});
&{$ref_DATA->{'FUNC_SAVE'}}($ref_DATA->{'DATA_CONTAINER'});}}}}sub CGI_hook_manual{my($ref_DATA)=@_;
$ref_DATA={}if(!defined$ref_DATA);
my$buffer_size=81920;
my$file_name=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'};
if(-f$file_name){return{'ID'=>0,'ERROR_MSG'=>"Manual uploading HOOK file ".&NL::String::get_right($file_name,40,1)." already exists"};}if(!&NL::File::Lock::lock_write($file_name,{'timeout'=>10,'time_sleep'=>0.1})){return{'ID'=>0,'ERROR_MSG'=>"Can't lock uploading HOOK file ".&NL::String::get_right($file_name,40,1)." for reading"};}$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'}=$file_name;
open(RAW_DATA,">$file_name")or return{'ID'=>0,'ERROR_MSG'=>"Can't open file ".&NL::String::get_right($file_name,40,1)." for WRITING: $!"};
close RAW_DATA or return{'ID'=>0,'ERROR_MSG'=>"Can't close file ".&NL::String::get_right($file_name,40,1).": $!"};
open(RAW_DATA,"+<$file_name")or return{'ID'=>0,'ERROR_MSG'=>"Can't open file ".&NL::String::get_right($file_name,40,1)." for READING/WRITING: $!"};
binmode RAW_DATA;
my$raw_FILEHANDLE=\*RAW_DATA;
flock($raw_FILEHANDLE,2);
seek($raw_FILEHANDLE,0,0);
select((select($raw_FILEHANDLE),$|=1)[0]);
my$DO_READ=1;
my$bytes_total=$ENV{'CONTENT_LENGTH'};
my$bytes_done=0;
my$buffer;
while($DO_READ&&$bytes_done<$bytes_total){my$bytes_read+=read(STDIN,$buffer,$buffer_size);
if(!defined$bytes_read||$bytes_read<=0){$DO_READ=0;}else{$bytes_done+=$bytes_read;
select(undef,undef,undef,0.05);
print$raw_FILEHANDLE $buffer;}}truncate($raw_FILEHANDLE,tell$raw_FILEHANDLE);
close$raw_FILEHANDLE or return{'ID'=>0,'ERROR_MSG'=>"Can't write POST DATA to file ".&NL::String::get_right($file_name,40,1).": $!"};
if($bytes_done<$bytes_total){unlink($file_name);
&NL::File::Lock::unlock($file_name);
return{'ID'=>0,'ERROR_MSG'=>"We have read lesser then 'CONTENT_LENGTH' (client cancelled uploading?)"};}else{&NL::File::Lock::unlock($file_name);
return{'ID'=>1,'FILE_NAME'=>$file_name};}}sub status_filename_make{return 'up_stat_'.$_[0].'.txt';}sub status_filename_make_RAW{return 'up_raw_'.$_[0].'_L_'.$_[1].'_T_'.$_[2].'.txt';}sub status_parameters_decode{return&NL::String::re_replace($_[0],[{qr/&#124;/=>'\|'},{qr/&amp;/=>'&'}]);}sub status_parameters_encode{return&NL::String::re_replace($_[0],[{qr/&/=>'&amp;'},{qr/\|/=>'&#124;'}]);}sub status_line_make{my($ref_HASH)=@_;
return join('|',map{$_.':'.(&status_parameters_encode($ref_HASH->{$_}));}sort keys%{$ref_HASH});}sub status_line_parse{my($str)=@_;
my%hash_result=map{$1=>&status_parameters_decode($2)if($_=~/^([^\:]+):(.*)$/);}split(/\|/,$str);
return\%hash_result;}sub status_save{my($ref_DATA,$in_IS_FINISHED)=@_;
$ref_DATA={}if(!defined$ref_DATA);
$in_IS_FINISHED=0 if(!defined$in_IS_FINISHED);
if(!$in_IS_FINISHED){if(defined$ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'}&&$ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'}>0){my$size_diff=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'}-$ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'};
if($size_diff<$ref_DATA->{'UPLOAD'}->{'TEMP'}->{'STATUS_UPDATE_SIZE_INTERVAL'}){if(time()-$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'}<5){return{'ID'=>1,'ERROR_MSG'=>'No saving needed'};}}}}else{$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'status'}='FINISHED';
$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'}=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_total'};
$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_name'}='';}my$LINE_STATUS=&status_line_make($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'});
my$file_name=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'};
my$file_ready_state=0;
if(!$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}){if(-f$file_name){return{'ID'=>0,'ERROR_MSG'=>"'CGI.pm' uploading HOOK file ".&NL::String::get_right($file_name,40,1)." already exists"};}if(&NL::File::Lock::lock_write($file_name,{'timeout'=>20,'time_sleep'=>0.1})){if(open(STATUS_FH,">$file_name")){if(close(STATUS_FH)){if(open(STATUS_FH,"+<$file_name")){my$fh=\*STATUS_FH;
select((select($fh),$|=1)[0]);
$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}=$fh;
$file_ready_state=2;}else{&NL::File::Lock::unlock($file_name);
return{'ID'=>0,'ERROR_MSG'=>"Unable to open file ".&NL::String::get_right($file_name,40,1)." for READING/WRITING: $!"};}}else{&NL::File::Lock::unlock($file_name);
return{'ID'=>0,'ERROR_MSG'=>"Unable to close (write) file ".&NL::String::get_right($file_name,40,1).": $!"};}}else{&NL::File::Lock::unlock($file_name);
return{'ID'=>0,'ERROR_MSG'=>"Unable to open (create) file ".&NL::String::get_right($file_name,40,1).": $!"};}}else{return{'ID'=>0,'ERROR_MSG'=>"Unable to lock file ".&NL::String::get_right($file_name,40,1)." for WRITING: $!"};}}else{$file_ready_state=1;}if($file_ready_state<=0){return{'ID'=>0,'ERROR_MSG'=>"Unknown error, 'file_ready_state' = $file_ready_state"};}else{if($file_ready_state<=1&&!$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'}){if(!&NL::File::Lock::lock_write($file_name,{'timeout'=>10,'time_sleep'=>0.05})){return{'ID'=>0,'ERROR_MSG'=>"Unable to lock file ".&NL::String::get_right($file_name,40,1)." for WRITING (file was opened before): $!"};}}my$STATUS_FH=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'};
seek($STATUS_FH,0,0);
print$STATUS_FH $LINE_STATUS;
truncate($STATUS_FH,tell$STATUS_FH);
$ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'}=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'};
if($in_IS_FINISHED){close($STATUS_FH);
$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}=undef;}$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'}=time();
&NL::File::Lock::unlock($file_name);
return{'ID'=>1,'ERROR_MSG'=>''};}}sub status_close{my($ref_DATA)=@_;
$ref_DATA={}if(!defined$ref_DATA);
if($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}){my$STATUS_FH=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'};
if($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'}){close($STATUS_FH);
unlink($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});
&NL::File::Lock::unlock($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});}else{close($STATUS_FH);
unlink($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});}$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}=undef;}elsif(defined$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'}&&$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'}ne ''){unlink($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});}}sub status_read{my($file_name)=@_;
my$result={'ID'=>0,'HASH'=>{}};
my@arr_status_file=();
if(defined$file_name&&-f$file_name){if(&NL::File::Lock::lock_read($file_name,{'timeout'=>3,'time_sleep'=>0.05})){if(open(STATUS_FH,"<$file_name")){@arr_status_file=<STATUS_FH>;
close(STATUS_FH);
&NL::File::Lock::unlock($file_name);}else{&NL::File::Lock::unlock($file_name);
return{'ID'=>0,'ERROR_MSG'=>"Unable to open file ".&NL::String::get_right($file_name,40,1)." for READING: $!"};}}else{return{'ID'=>0,'ERROR_MSG'=>"Unable to lock file ".&NL::String::get_right($file_name,40,1)." for READING: $!"};}}else{my$err_msg='';
if(!defined$file_name){$err_msg="No file specified";}else{$err_msg="File ".&NL::String::get_right($file_name,40,1)." does not exists";}return{'ID'=>0,'ERROR_MSG'=>$err_msg};}my$data_is_EXISTS=0;
my$data_HASH={};
if(scalar@arr_status_file>0){foreach(@arr_status_file){$_=~s/^[\n\r]+//;
$_=~s/[\n\r]+$//;
if($_ ne ''){$data_is_EXISTS=1;
$data_HASH=&status_line_parse($_);
last;}}}if(!$data_is_EXISTS){return{'ID'=>0,'ERROR_MSG'=>"File ".&NL::String::get_right($file_name,40,1)." does not contain TEXT DATA"};}else{return{'ID'=>1,'STATUS'=>$data_HASH,'ERROR_MSG'=>''};}}sub status_get{my($in_SID,$in_SETTINGS)=@_;
$in_SID='' if(!defined$in_SID);
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'METHOD'}='' if(!defined$in_SETTINGS->{'METHOD'});
my$RESULT={'ID'=>0,'ERROR_MSG'=>'','STATUS'=>'','METHOD'=>''};
if($in_SID eq ''){$RESULT->{'ERROR_MSG'}="No 'SID' specified";return$RESULT;}if($in_SETTINGS->{'METHOD'}!~/^(STATUS_FILE|POST_FILE)$/){if($NL::AJAX::Upload::CGI_PM_LOADED&&$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK){$in_SETTINGS->{'METHOD'}='STATUS_FILE';}else{$in_SETTINGS->{'METHOD'}='POST_FILE';}}$RESULT->{'METHOD'}=$in_SETTINGS->{'METHOD'};
my$DIR_TEMP=$NL::Upload::DATA->{'DYNAMIC'}->{'DIR_TEMP'};
if(defined$in_SETTINGS->{'DIR_TEMP'}&&$in_SETTINGS->{'DIR_TEMP'}ne ''){$DIR_TEMP=$in_SETTINGS->{'DIR_TEMP'};}if($DIR_TEMP ne ''){my$dir_splitter=&NL::Dir::get_dir_splitter();
$DIR_TEMP.=$dir_splitter if($DIR_TEMP!~/${dir_splitter}$/);}my$hash_STATUS={};
if($in_SETTINGS->{'METHOD'}eq 'STATUS_FILE'){my$filename=$DIR_TEMP.&status_filename_make($in_SID);
my$status_read_RESULT=&status_read($filename);
if($status_read_RESULT->{'ID'}){$hash_STATUS=$status_read_RESULT->{'STATUS'};}else{$RESULT->{'ERROR_MSG'}=$status_read_RESULT->{'ERROR_MSG'};return$RESULT;}}else{my$DIR_OPEN=$DIR_TEMP ne ''?$DIR_TEMP:'.';
if(opendir(DIR,$DIR_OPEN)){my$is_OK=0;
my$SIDQM=quotemeta($in_SID);
my@arr_listing=grep(/^up_raw_$SIDQM.*\.txt$/,readdir(DIR));
closedir(DIR);
if(scalar@arr_listing==1){my$file_name=$DIR_TEMP.$arr_listing[0];
if(-f$file_name){my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)=stat($file_name);
if(defined$size&&$size>=0){if($arr_listing[0]=~/L_(.*)_T_(.*)\.txt$/){$is_OK=1;
$hash_STATUS->{'size_current'}=$size;
$hash_STATUS->{'size_total'}=$1;
$hash_STATUS->{'time_start'}=$2;}}}}if(!$is_OK){$RESULT->{'ERROR_MSG'}="No status file (or file is incorrect) for SID = '$in_SID' (METHOD = '".$in_SETTINGS->{'METHOD'}."')";
return$RESULT;}}else{$RESULT->{'ERROR_MSG'}="Unable to open directory '".&NL::String::get_right($DIR_OPEN,40,1)."' (SID = '$in_SID')";
return$RESULT;}}my$error_message='';
if(!defined$hash_STATUS->{'size_total'}||$hash_STATUS->{'size_total'}!~/^\d+$/){$error_message="'size_total' is incorrect";}elsif(!defined$hash_STATUS->{'size_current'}||$hash_STATUS->{'size_current'}!~/^\d+$/){$error_message="'size_current' is incorrect";}elsif(!defined$hash_STATUS->{'time_start'}||$hash_STATUS->{'time_start'}!~/^\d+$/){$error_message="'time_start' is incorrect";}else{$hash_STATUS->{'time_spent'}=time()-$hash_STATUS->{'time_start'};
if(defined$hash_STATUS->{'file_current_number'}&&$hash_STATUS->{'file_current_number'}!~/^\d+$/){$error_message="'file_current_number' is incorrect";}}if($error_message ne ''){$RESULT->{'ERROR_MSG'}="Incorrect STATUS parameters ($error_message)";
return$RESULT;}else{$hash_STATUS->{'status'}='UPLOADING' if(!defined$hash_STATUS->{'status'});
$RESULT->{'ID'}=1;
$RESULT->{'STATUS'}=$hash_STATUS;
return$RESULT;}}sub CGI_process_uploads{my($CGI_QUERY,$in_SETTINGS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'FILES_PERMISSIONS'}='' if(!defined$in_SETTINGS->{'FILES_PERMISSIONS'});
$in_SETTINGS->{'BINMODE'}=1 if(!defined$in_SETTINGS->{'BINMODE'});
my@CGI_FILES;
foreach($CGI_QUERY->param){if($_=~/^file_\d+$/){push@CGI_FILES,$_;}}my$CGI_FILES_INFO=[];
my$file_permissions=oct($in_SETTINGS->{'FILES_PERMISSIONS'});
foreach(@CGI_FILES){my$file_name=&CGI_process_uploads_GET_FILE_NAME(''.$CGI_QUERY->param($_));
my$file_handle=&CGI::upload($_);
my$temp_FILE=$CGI_QUERY->tmpFileName($file_handle);
my$is_copyed=0;
if(!defined$temp_FILE||$temp_FILE eq ''||!(-f$temp_FILE)||!rename($temp_FILE,$file_name)){if(open(UPLOADFILE,">$file_name")){binmode UPLOADFILE if($in_SETTINGS->{'BINMODE'});
while(<$file_handle>){print UPLOADFILE;}close(UPLOADFILE);
$is_copyed=1;}else{push@{$CGI_FILES_INFO},{'file'=>$file_name,'status'=>0,'ERROR_MSG'=>"Unable to create file '$file_name': $!"};}}else{$is_copyed=1;}if($is_copyed){my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$file_size,$atime,$mtime,$ctime,$blksize,$blocks)=stat($file_name);
my$error_msg='';
if($in_SETTINGS->{'FILES_PERMISSIONS'}ne ''){if(!chmod$file_permissions,$file_name){$error_msg="Unable to chmod '".$in_SETTINGS->{'file_permissions'}."' file '$file_name': $!";}}push@{$CGI_FILES_INFO},{'file'=>$file_name,'status'=>1,'size'=>$file_size,'ERROR_MSG'=>$error_msg};}}return$CGI_FILES_INFO;}sub CGI_process_uploads_GET_FILE_NAME{my($in_value)=@_;
my@arr_splitters=('\/','\\','\:');
&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$in_value);
foreach my $splitter(@arr_splitters){$splitter=~s/\\/\\\\/g;
$splitter=~s/\:/\\\:/g;
$in_value=~s/^.*$splitter([^$splitter]{0,})$/$1/;}return$in_value;}sub make_upload_info{my($ref_DATA,$in_SETTINGS)=@_;
$ref_DATA={}if(!defined$ref_DATA);
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'FILES_PERMISSIONS'}='' if(!defined$in_SETTINGS->{'FILES_PERMISSIONS'});
&WC::Dir::update_current_dir();
my$dir_current=&WC::Dir::get_current_dir();
my$result={};
$result->{'js_ID'}=$ref_DATA->{'UPLOAD'}->{'SID'};
$result->{'dir_current'}=$dir_current;
$result->{'size_total'}=$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_total'};
$result->{'time_spent'}=time()-$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'time_start'};
$result->{'files_chmod'}='';
if(defined$in_SETTINGS->{'FILES_PERMISSIONS'}&&$in_SETTINGS->{'FILES_PERMISSIONS'}ne ''){$result->{'files_chmod'}=$in_SETTINGS->{'FILES_PERMISSIONS'};}return$result;}END{if(defined$NL::Upload::DATA->{'ACTIVE_OBJECT'}&&defined$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}&&defined$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'METHOD'}&&$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'METHOD'}ne ''&&defined$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}&&defined$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'}&&$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'}ne ''){if($NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'METHOD'}eq 'STATUS_FILE'){&status_close($NL::Upload::DATA->{'ACTIVE_OBJECT'});}else{unlink($NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'})if(-f$NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'});
&NL::File::Lock::unlock($NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'});}}}package NL::Report;
use strict;
$NL::Report::DATA={'CONST'=>{'REQUIRED_ALWAYS'=>['TYPE'],},'SETTINGS'=>{'VALUES_TO_HTML'=>1,'TYPES'=>['ERROR','WARNING','INFORMATION'],'REQUIRED_IN'=>['message'],'TEMPLATES'=>{'_ELEMENTS_SPLITTER_'=>"\n---\n",'_REPORT_TYPES_'=>{'ERROR'=>"[_BEFORE]TITLE: [_TITLE]\n[\nHeader: [_HEADER]\n\n][_REPORT_ELEMENTS_][\n\nfooter: [_FOOTER]][_AFTER]",'WARNING'=>"[_BEFORE][_TITLE]\n[\nHeader: [_HEADER]\n\n][_REPORT_ELEMENTS_][\n\nfooter: [_FOOTER]][_AFTER]",'_REPORT_ELEMENTS_'=>{'ERROR'=>"ERROR: [message][_INFO_][_FAQ_ID_]",'WARNING'=>"WARNING: [message][_INFO_][_FAQ_ID_]",'_ELEMENT_PARTS_'=>{'_INFO_'=>"[\nINFO: [info]]",'_FAQ_ID_'=>"[\nFAQ_ID: [id]]"}}}}}};
sub init{my($in_SETTINGS)=@_;
if($in_SETTINGS){$NL::Report::DATA->{'SETTINGS'}=$in_SETTINGS;}}sub make_REPORT{return&make_REPORT_EXT($NL::Report::DATA->{'SETTINGS'},@_);}sub make_REPORT_EXT{my($report_SETTINGS,$in_HASH,$in_PARAMETERS)=@_;
$in_PARAMETERS={}if(!defined$in_PARAMETERS);
my$report_CONST=$NL::Report::DATA->{'CONST'};
my($report_TYPE_id,$report_TYPE_name)=(-1,'');
my($result_TEXT,$result_ELEMENTS)=('','');
foreach my $hash_ITEM(@{$in_HASH}){my$skip_ITEM=0;
foreach(@{$report_CONST->{'REQUIRED_ALWAYS'}},@{$report_SETTINGS->{'REQUIRED_IN'}}){if(!defined$hash_ITEM->{$_}||$hash_ITEM->{$_}eq ''){$skip_ITEM=1;
last;}}next if($skip_ITEM);
my$type_index=0;
foreach(@{$report_SETTINGS->{'TYPES'}}){if($_ eq$hash_ITEM->{'TYPE'}){if($report_TYPE_id<0||$report_TYPE_id>$type_index){$report_TYPE_id=$type_index;
$report_TYPE_name=$_;}last;}$type_index++;}my$element_TEXT=&make_ELEMENT($report_SETTINGS,$hash_ITEM->{'TYPE'},$hash_ITEM);
if($element_TEXT ne ''){$result_ELEMENTS.=$report_SETTINGS->{'TEMPLATES'}->{'_ELEMENTS_SPLITTER_'}if($result_ELEMENTS ne ''&&defined$report_SETTINGS->{'TEMPLATES'}->{'_ELEMENTS_SPLITTER_'});
$result_ELEMENTS.=$element_TEXT;}}if($report_TYPE_name ne ''&&$result_ELEMENTS ne ''&&defined$report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{$report_TYPE_name}){my$report_VARS={'_BEFORE'=>['ALL_BEFORE','[TYPE]_BEFORE'],'_AFTER'=>['ALL_AFTER','[TYPE]_AFTER'],'_TITLE'=>['ALL_title','[TYPE]_title'],'_HEADER'=>['ALL_header','[TYPE]_header'],'_FOOTER'=>['ALL_footer','[TYPE]_footer']};
foreach(keys%{$report_VARS}){my$value='';
foreach my $name(@{$report_VARS->{$_}}){$name=~s/\[TYPE\]/$report_TYPE_name/;
if(defined$in_PARAMETERS->{$name}){$value=$in_PARAMETERS->{$name};
last;}}$report_VARS->{$_}=$value;}if($report_VARS->{'_TITLE'}eq ''){$report_VARS->{'_TITLE'}="Report ($report_TYPE_name):";}$report_VARS->{'_REPORT_ELEMENTS_'}=$result_ELEMENTS;
$result_TEXT=&make_REPLACE($report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{$report_TYPE_name},$report_VARS,{'REGEX'=>qr/[A-Z_\-]+/});}return{'TYPE'=>$report_TYPE_name,'TEXT'=>$result_TEXT};}sub make_ELEMENT{my($report_SETTINGS,$in_ELEMENT_ID,$in_HASH)=@_;
my$result='';
if($in_ELEMENT_ID!~/^_(.*)_$/){my$report_ELEMENTS=$report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{'_REPORT_ELEMENTS_'};
if(defined$report_ELEMENTS->{$in_ELEMENT_ID}){$result=&make_REPLACE($report_ELEMENTS->{$in_ELEMENT_ID},$in_HASH,{'REGEX'=>qr/[a-z][a-z_\-]{0,}[a-z]{0,}/,'to_HTML'=>(defined$report_SETTINGS->{'VALUES_TO_HTML'})?$report_SETTINGS->{'VALUES_TO_HTML'}:0});
$result=&make_REPLACE_PART($report_SETTINGS,$result,$in_HASH);}}return$result;}sub make_REPLACE_PART{my($report_SETTINGS,$in_VAL,$in_HASH)=@_;
my$report_PARTS=$report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{'_REPORT_ELEMENTS_'}->{'_ELEMENT_PARTS_'};
my$toREPLACE={};
while($in_VAL=~/\[(_[A-Z |_\-]+_)\]/g){my$id=$1;
my@arr_elements=split(/[ ]{0,}\|\|[ ]{0,}/,$id);
$id=~s/\|/\\\|/g;
my$value='';
foreach(@arr_elements){if(defined$report_PARTS->{$_}){$value=&make_REPLACE($report_PARTS->{$_},$in_HASH,{'REGEX'=>qr/[a-z][a-z_\-]{0,}[a-z]{0,}/,'to_HTML'=>(defined$report_SETTINGS->{'VALUES_TO_HTML'})?$report_SETTINGS->{'VALUES_TO_HTML'}:0});
last if($value ne '');}}$toREPLACE->{$id}=$value;}foreach(keys%{$toREPLACE}){$in_VAL=~s/\[$_\]/$toREPLACE->{$_}/g;}return$in_VAL;}sub make_REPLACE{my($in_VAL,$in_HASH,$in_PARAMETERS)=@_;
$in_PARAMETERS={}if(!defined$in_PARAMETERS);
return '' if(!defined$in_VAL||$in_VAL eq '');
my$regex=qr/[A-Za-z_\-]+/;
$regex=$in_PARAMETERS->{'REGEX'}if(defined$in_PARAMETERS->{'REGEX'});
my$toREPLACE={};
while($in_VAL=~/\[($regex)\]/g){if(!defined$toREPLACE->{$1}){$toREPLACE->{$1}=(defined$in_HASH->{$1})?$in_HASH->{$1}:'';}}foreach(keys%{$toREPLACE}){my$from="[$_]";
my$to=$toREPLACE->{$_};
if(defined$in_PARAMETERS->{'to_HTML'}&&$in_PARAMETERS->{'to_HTML'}){$to=~s/\n/<br \/>/g;}if($in_VAL=~/(\[([^\[\]]{0,})\[$_\]([^\[\]]{0,})\])/){$from=$1;
$to=$2.$to.$3 if($to ne '');}$from=~s/\[/\\\[/g;$from=~s/\]/\\\]/g;
$in_VAL=~s/$from/$to/;}return$in_VAL;}package WC::Encode;
use strict;
$WC::Encode::POSIX_ON=1;
eval{require POSIX;};
if($@){$WC::Encode::POSIX_ON=0;
$WC::Encode::POSIX_ERROR=$@;}$WC::Encode::ENCODE_ON=1;
eval{require Encode;};
if($@){$WC::Encode::ENCODE_ON=0;
$WC::Encode::ENCODE_ERROR=$@;}sub init{$WC::c->{'config'}->{'encodings'}={}if(!defined$WC::c->{'config'}->{'encodings'});
$WC::c->{'config'}->{'encodings'}->{'internal'}='utf8' if(!defined$WC::c->{'config'}->{'encodings'}->{'internal'});
$WC::c->{'config'}->{'encodings'}->{'server_console'}='' if(!defined$WC::c->{'config'}->{'encodings'}->{'server_console'});
$WC::c->{'config'}->{'encodings'}->{'server_system'}='' if(!defined$WC::c->{'config'}->{'encodings'}->{'server_system'});
$WC::c->{'config'}->{'encodings'}->{'editor_text'}='' if(!defined$WC::c->{'config'}->{'encodings'}->{'editor_text'});
$WC::c->{'config'}->{'encodings'}->{'file_download'}='' if(!defined$WC::c->{'config'}->{'encodings'}->{'file_download'});
if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_system'}eq ''){$WC::c->{'config'}->{'encodings'}->{'server_system'}=$WC::c->{'config'}->{'encodings'}->{'server_console'}}}else{if($WC::c->{'config'}->{'encodings'}->{'server_console'}eq ''){$WC::c->{'config'}->{'encodings'}->{'server_console'}=$WC::c->{'config'}->{'encodings'}->{'server_system'}}}}sub IS_ENCODE_ON{return$WC::Encode::ENCODE_ON;}sub IS_POSIX_ON{return$WC::Encode::POSIX_ON;}sub IS_ON{return($WC::Encode::ENCODE_ON&&$WC::Encode::POSIX_ON)?1:0;}sub get_encoding{my($in_NAME)=@_;
if(defined$in_NAME&&$in_NAME ne ''&&defined$WC::c->{'config'}->{'encodings'}->{$in_NAME}){return$WC::c->{'config'}->{'encodings'}->{$in_NAME};}return '';}sub encode_FROM_TO{if($WC::Encode::ENCODE_ON){return&Encode::from_to(@_);}else{return 0;}}sub encode_from_CGI{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){my$server_system_encoding=($WC::c->{'config'}->{'encodings'}->{'server_system'}ne '')?$WC::c->{'config'}->{'encodings'}->{'server_system'}:'utf8';
if(index(${$in_ref_val},'%u')>=0){${$in_ref_val}=~s/%u([0-9A-Fa-f]{1,4})/&_encode_from_CGI_UCS_2BE($1, $server_system_encoding)/eg;}}}sub _encode_from_CGI_UCS_2BE{my($in_char,$in_ENCODING)=@_;
$in_char=pack('n',hex($in_char));
&encode_FROM_TO($in_char,'UCS-2BE',$in_ENCODING);
return$in_char;}sub encode_from_CONSOLE_to_SYSTEM{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'server_system'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne$WC::c->{'config'}->{'encodings'}->{'server_system'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'server_console'},$WC::c->{'config'}->{'encodings'}->{'server_system'});}}}}sub encode_from_CONSOLE_to_INTERNAL{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'internal'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne$WC::c->{'config'}->{'encodings'}->{'internal'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'server_console'},$WC::c->{'config'}->{'encodings'}->{'internal'});}}}}sub encode_from_SYSTEM_to_INTERNAL{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'internal'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne$WC::c->{'config'}->{'encodings'}->{'internal'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'server_system'},$WC::c->{'config'}->{'encodings'}->{'internal'});}}}}sub encode_from_INTERNAL_to_CONSOLE{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'internal'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne$WC::c->{'config'}->{'encodings'}->{'internal'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'internal'},$WC::c->{'config'}->{'encodings'}->{'server_console'});}}}}sub encode_from_INTERNAL_to_SYSTEM{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'internal'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne$WC::c->{'config'}->{'encodings'}->{'internal'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'internal'},$WC::c->{'config'}->{'encodings'}->{'server_system'});}}}}sub encode_from_FILE_to_SYSTEM{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'editor_text'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne$WC::c->{'config'}->{'encodings'}->{'editor_text'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'editor_text'},$WC::c->{'config'}->{'encodings'}->{'server_system'});}}}}sub encode_from_SYSTEM_to_FILE{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'editor_text'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne$WC::c->{'config'}->{'encodings'}->{'editor_text'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'server_system'},$WC::c->{'config'}->{'encodings'}->{'editor_text'});}}}}sub encode_from_SYSTEM_to_FILE_DOWNLOAD{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'file_download'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'server_system'}ne$WC::c->{'config'}->{'encodings'}->{'file_download'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'server_system'},$WC::c->{'config'}->{'encodings'}->{'file_download'});}}}}sub encode_from_INTERNAL_to_FILE_DOWNLOAD{my($in_ref_val)=@_;
if($WC::Encode::ENCODE_ON){if($WC::c->{'config'}->{'encodings'}->{'internal'}ne ''&&$WC::c->{'config'}->{'encodings'}->{'file_download'}ne ''){if($WC::c->{'config'}->{'encodings'}->{'internal'}ne$WC::c->{'config'}->{'encodings'}->{'file_download'}){&encode_FROM_TO(${$in_ref_val},$WC::c->{'config'}->{'encodings'}->{'internal'},$WC::c->{'config'}->{'encodings'}->{'file_download'});}}}}package WC::CORE;
use strict;
$WC::CONST={'MOD_PERL_ON'=>(defined$ENV{'MOD_PERL'})?1:0,'APP_SETTINGS'=>{'name'=>'Web Console'},'VERSION'=>{'NUMBER'=>'0.2.6','DATE'=>'2010.11.12'},'DEBUG'=>0,'CHMODS'=>{'CONFIGS'=>'755','.HTACCESS'=>'644'},'URLS'=>{'SITE'=>'http://www.web-console.org','BUGS'=>'http://www.web-console.org/bugs/','FEATURE_REQUESTS'=>'http://www.web-console.org/feature_requests/','FAQ'=>'http://www.web-console.org/faq/','FAQ_ID'=>'http://www.web-console.org/faq/#','DOWNLOAD'=>'http://www.web-console.org/download/','USAGE'=>'http://www.web-console.org/usage/','FORUM'=>'http://forum.web-console.org','ADDONS'=>'http://addons.web-console.org','SERVICES'=>'http://services.web-console.org','ABOUT_US'=>'http://www.web-console.org/about_us/'},'INTERNAL'=>{'HEADER_PREFIX'=>'Web Console: ','MAX_EDIT_FILE_SIZE'=>1048576,'HEADERS'=>{'content-type'=>{'default'=>'Content-type: text/html; charset=utf-8','sub'=>sub{my($in)=@_;
my$result={};
if(defined$in&&$in ne ''&&$in=~/^[ ]{0,}Content-type:[ ]+([^ ]+);([ ]+charset=([^ ]+);?)?[ ]{0,}$/i){$result->{'name'}='content-type';
$result->{'type'}=$1;
$result->{'charset'}=defined$3?$3:'';}return$result;}}}},'HTTP_EXTRA_HEADERS'=>['X-Powered-By: Web Console (http://www.web-console.org)']};
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub die_exit{exit;}sub die_error{&WC::Response::show_error(@_);&die_exit();}sub die_error_no_header{&WC::Response::show_error_no_header(@_);&die_exit();}sub die_info{&WC::Response::show_info(@_);&die_exit();}sub die_info_no_header{&WC::Response::show_info_no_header(@_);&die_exit();}sub die_warning{&WC::Response::show_warning(@_);&die_exit();}sub die_warning_no_header{&WC::Response::show_warning_no_header(@_);&die_exit();}sub die_error_AJAX{&WC::Response::show_error_AJAX(@_);&die_exit();}sub die_error_HTML{&WC::Response::show_error_HTML(@_);&die_exit();}sub die_error_TEXT{&WC::Response::show_error_TEXT(@_);&die_exit();}sub die_info_AJAX{&WC::Response::show_info_AJAX(@_);&die_exit();}sub die_info_HTML{&WC::Response::show_info_HTML(@_);&die_exit();}sub die_info_TEXT{&WC::Response::show_info_TEXT(@_);&die_exit();}sub die_warning_AJAX{&WC::Response::show_warning_AJAX(@_);&die_exit();}sub die_warning_HTML{&WC::Response::show_warning_HTML(@_);&die_exit();}sub die_warning_TEXT{&WC::Response::show_warning_TEXT(@_);&die_exit();}sub die_error_AJAX_no_header{&WC::Response::show_error_AJAX_no_header(@_);&die_exit();}sub die_error_HTML_no_header{&WC::Response::show_error_HTML_no_header(@_);&die_exit();}sub die_error_TEXT_no_header{&WC::Response::show_error_TEXT_no_header(@_);&die_exit();}sub die_info_AJAX_no_header{&WC::Response::show_info_AJAX_no_header(@_);&die_exit();}sub die_info_HTML_no_header{&WC::Response::show_info_HTML_no_header(@_);&die_exit();}sub die_info_TEXT_no_header{&WC::Response::show_info_TEXT_no_header(@_);&die_exit();}sub die_warning_AJAX_no_header{&WC::Response::show_warning_AJAX_no_header(@_);&die_exit();}sub die_warning_HTML_no_header{&WC::Response::show_warning_HTML_no_header(@_);&die_exit();}sub die_warning_TEXT_no_header{&WC::Response::show_warning_TEXT_no_header(@_);&die_exit();}sub start{$WC::context={};
*WC::c=\$WC::context;
$WC::c->{'APP_SETTINGS'}={'name'=>$WC::CONST->{'APP_SETTINGS'}->{'name'},'dir_path'=>'','file_path'=>$0,'file_name'=>''};
$WC::c->{'ACTION'}='';
$WC::c->{'config'}={};
$WC::c->{'user'}={};
$WC::c->{'stash'}={};
$WC::c->{'state'}={};
$WC::c->{'request'}={'params'=>{},'cmd'=>'','cmd_'=>'','cmd_params'=>'','cmd_params_arr'=>[]};
$WC::c->{'response'}={'type'=>'HTML','text'=>'','ajax_data'=>{}};
$WC::c->{'req'}=$WC::c->{'request'};
$WC::c->{'res'}=$WC::c->{'response'};
$WC::ENGINE_LOADED=1;
&WC::Dir::init();
$WC::c->{'APP_SETTINGS'}->{'file_name'}=&WC::File::get_name($WC::c->{'APP_SETTINGS'}->{'file_path'});
$WC::c->{'APP_SETTINGS'}->{'dir_path'}=&WC::File::get_dir($WC::c->{'APP_SETTINGS'}->{'file_path'});
if($WC::CONST->{'MOD_PERL_ON'}){&WC::Dir::change_dir($WC::c->{'APP_SETTINGS'}->{'dir_path'});
&WC::Response::show_HTML_PAGE('html_MOD_PERL');
return;}&WC::Config::Main::init_variables_defaults();
&WC::CGI::init();
&WC::CGI::get_input_from_GET_SET();
if(&WC::AJAX::init()){$WC::c->{'response'}->{'type'}='AJAX';}my$IS_WEB_CONSOLE_INSTALLED=&WC::Install::CHECK_IS_WEB_CONSOLE_INSTALLED();
if($IS_WEB_CONSOLE_INSTALLED==0){if(!&WC::File::lock_init($WC::c->{'config'}->{'directorys'}->{'home'},1)){&WC::CORE::die_error(&WC::File::get_last_error_ARR());}&WC::CGI::get_input_from_POST_UPDATE();
&WC::Install::start();}elsif($IS_WEB_CONSOLE_INSTALLED==1){if(&WC::Config::Main::load()!=1){&WC::CORE::die_error(&WC::Config::get_last_error_ARR());}else{if(!&WC::File::lock_init($WC::c->{'config'}->{'directorys'}->{'temp'})){&WC::CORE::die_error(&WC::File::get_last_error_ARR());}&WC::Encode::init();
&WC::EXEC::init();
if(&WC::Users::init()!=1){&WC::CORE::die_error(&WC::Users::get_last_error_ARR());}else{if($WC::c->{'config'}->{'directorys'}->{'work'}ne ''){if(!&WC::Dir::change_dir($WC::c->{'config'}->{'directorys'}->{'work'})){&WC::Warning::add("Unable change directory to WORK DIRECTORY = '".$WC::c->{'config'}->{'directorys'}->{'work'}."'",$!);}}&ACTION_process();}}}else{&WC::CORE::die_error(&WC::Install::get_last_error_ARR());}}sub ACTION_update_from_Q_ACTION{if(defined$WC::c->{'req'}->{'params'}->{'q_action'}){if($WC::c->{'req'}->{'params'}->{'q_action'}ne ''){$WC::c->{'ACTION'}=$WC::c->{'req'}->{'params'}->{'q_action'};}return 1;}return 0;}sub ACTION_process{my$is_LOG_PASS_from_GET=(defined$WC::c->{'req'}->{'params'}->{'user_login'}||defined$WC::c->{'req'}->{'params'}->{'user_password'});
if(!&ACTION_update_from_Q_ACTION()){&WC::CGI::get_input_from_POST_UPDATE();
&ACTION_update_from_Q_ACTION();}if($is_LOG_PASS_from_GET&&$WC::c->{'ACTION'}eq 'logon'){$WC::c->{'ACTION'}='';}my$is_INCORRECT_CALL=0;
if($WC::c->{'ACTION'}eq ''){$WC::c->{'response'}->{'type'}='HTML';
&WC::Response::show_HTML_PAGE('html_logon');}elsif($WC::c->{'ACTION'}eq 'logon'){$WC::c->{'response'}->{'type'}='HTML';
&WC::CGI::get_input_from_POST_UPDATE();
if(&WC::Users::authenticate('HTML')){&WC::Response::show_HTML_PAGE('html_console',{'user_login'=>&NL::String::str_escape_JSON($WC::c->{'req'}->{'params'}->{'user_login'}),'user_password_encrypted'=>&NL::String::str_escape_JSON($WC::c->{'req'}->{'params'}->{'user_password'})});}}elsif($WC::c->{'ACTION'}eq 'download'){if(&WC::Users::authenticate('HTML')){&WC::Response::Download::start($WC::c->{'req'}->{'params'});}}elsif($WC::c->{'ACTION'}=~/^AJAX_[^\s]+$/){if($WC::c->{'response'}->{'type'}eq 'AJAX'){if(!$is_LOG_PASS_from_GET){&WC::CGI::get_input_from_POST_UPDATE();}if(&WC::Users::authenticate('AJAX')){if(!&ACTION_process_AJAX($WC::c->{'ACTION'})){$is_INCORRECT_CALL=1;}}}else{$is_INCORRECT_CALL=1;}}else{$is_INCORRECT_CALL=1;}if($is_INCORRECT_CALL){&die_info('Incorrect '.$WC::c->{'APP_SETTINGS'}->{'name'}.' call','Undefined '.$WC::c->{'APP_SETTINGS'}->{'name'}.' action was called or action needs more parameter(s), are you hacker?','WC_CORE_UNDEFINED_ACTION');}}sub ACTION_process_AJAX{my($in_ACTION)=@_;
return 0 if(!defined$in_ACTION||$in_ACTION eq '');
if($in_ACTION eq 'AJAX_CMD'){if(&WC::EXEC::init_INPUT_CMD()){my$name_not_contain='\|';
if(!&WC::Dir::change_dir_TO_CURRENT()&&$WC::c->{'request'}->{'cmd'}!~/^[ \t]{0,}cd( [ \t]{0,}([^$name_not_contain]{0,})[ \t]{0,}|)$/i){&WC::CORE::die_info_AJAX(&WC::Dir::get_last_error_ARR());}else{if($WC::c->{'request'}->{'cmd'}=~/^cd( [ \t]{0,}([^$name_not_contain]{0,})[ \t]{0,}|)$/i){my$dir='';
if(defined$2&&$2 ne ''){$dir=&NL::String::str_trim($2);
$dir=&WC::Dir::check_in($dir);}$dir=$WC::c->{'config'}->{'directorys'}->{'work'}if($dir eq '');
if(&WC::Dir::change_dir($dir)){$dir=&WC::Dir::get_current_dir();
&WC::Response::show_AJAX_RESPONSE('DIR_CHANGE','',{'dir_now'=>$dir,'JS_REQUEST_ID'=>&NL::AJAX::get_request_id()});}else{&WC::Response::show_AJAX_RESPONSE('CMD_RESULT','<div class="t-lime">'.$WC::c->{'APP_SETTINGS'}->{'name'}." unable change directory to ".(&WC::HTML::get_short_value($dir,{'MAX_LENGTH'=>55})).':</div>'.'<div class="t-blue">&nbsp;&nbsp; - '.(($!&&$!ne '')?$!:'Unknown error').'</div>'.'<span class="t-green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you are trying to execute few commands as \'one-liner\' and first<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;command is "cd", please add space character before first "cd" command.');}}else{my$internal_exec=&WC::Internal::exec_autocompletion($WC::c->{'request'}->{'cmd'});
if($internal_exec->{'ID'}){if(defined$internal_exec->{'SHOW_AS_TAB_RESULT'}&&$internal_exec->{'SHOW_AS_TAB_RESULT'}){my$hash_RESULT=$internal_exec;
delete$hash_RESULT->{'ID'};
delete$hash_RESULT->{'SHOW_AS_TAB_RESULT'};
$hash_RESULT->{'ALWAYS_SHOW'}=1;
$hash_RESULT->{'str_IN'}='';
$hash_RESULT->{'cmd_add'}='';
$hash_RESULT->{'values'}=[];
foreach('INFO','SUBTITLE'){&NL::String::str_HTML_full(\$hash_RESULT->{$_})if(defined$hash_RESULT->{$_});}if(defined$hash_RESULT->{'TEXT'}&&$hash_RESULT->{'TEXT'}ne ''){my$hash_internal=&WC::Internal::process_output(\$hash_RESULT->{'TEXT'},$hash_RESULT->{'BACK_STASH'});
&NL::Utils::hash_update($hash_RESULT,$hash_internal);}&WC::Response::show_AJAX_RESPONSE('TAB_RESULT','',$hash_RESULT);}else{my$hash_internal=&WC::Internal::process_output(\$internal_exec->{'text'},$internal_exec->{'BACK_STASH'})if(defined$internal_exec->{'text'}&&$internal_exec->{'text'}ne '');
&WC::Response::show_AJAX_RESPONSE_NO_TEXT_ENCODE('CMD_RESULT',$internal_exec->{'text'},$hash_internal);}}else{my$result_EXEC=&WC::EXEC::execute_encoding_WC($WC::c->{'request'}->{'cmd'});
if($result_EXEC->{'ID'}==1){&WC::Response::show_AJAX_RESPONSE_NO_TEXT_ENCODE('CMD_RESULT',&NL::String::str_HTML_full($result_EXEC->{'text'}));}else{&WC::CORE::die_info_AJAX("Unable to execute command '".(&NL::String::str_HTML_full($WC::c->{'request'}->{'cmd'}))."'",&NL::String::str_HTML_full(@{$result_EXEC->{'error'}}[1]),'AJAX_CMD_UNABLE_EXECUTE');}}}}return 1;}else{return 0;}}elsif($in_ACTION eq 'AJAX_TAB'){if(defined$WC::c->{'req'}->{'params'}->{'cmd_query'}){my$auto=&WC::Autocomplete::start($WC::c->{'req'}->{'params'}->{'cmd_query'});
if($auto->{'ID'}){my$hash_RESULT=$auto;
delete$hash_RESULT->{'ID'};
$hash_RESULT->{'str_IN'}=$WC::c->{'req'}->{'params'}->{'cmd_query'};
foreach('INFO','SUBTITLE'){&NL::String::str_HTML_full(\$hash_RESULT->{$_})if(defined$hash_RESULT->{$_});}if(defined$hash_RESULT->{'TEXT'}&&$hash_RESULT->{'TEXT'}ne ''){my$hash_internal=&WC::Internal::process_output(\$hash_RESULT->{'TEXT'});
&NL::Utils::hash_update($hash_RESULT,$hash_internal);}if(defined$hash_RESULT->{'values'}){foreach(@{$hash_RESULT->{'values'}}){&NL::String::str_HTML_full(\$_);}}&WC::Response::show_AJAX_RESPONSE('TAB_RESULT','',$hash_RESULT);}else{delete$auto->{'ID'};
&WC::Response::show_AJAX_RESPONSE('TAB_RESULT','',$auto);}return 1;}else{return 0;}}elsif($in_ACTION eq 'AJAX_FILE_SAVE'){if(&WC::Internal::Data::File::AJAX_save($WC::c->{'req'}->{'params'})){return 1;}}elsif($in_ACTION eq 'AJAX_FILE_SAVE_CLOSE'){if(&WC::Internal::Data::File::AJAX_save($WC::c->{'req'}->{'params'},1)){return 1;}}elsif($in_ACTION eq 'AJAX_UPLOAD'){if(&WC::Upload::process()){return 1;}}elsif($in_ACTION eq 'AJAX_UPLOAD_STATUS'){if(&WC::Upload::process_get_status()){return 1;}}return 0;}package WC::EXEC;
use strict;
sub init{if($WC::Encode::POSIX_ON){&POSIX::setlocale(&POSIX::LC_ALL,$WC::c->{'config'}->{'encodings'}->{'server_console'})if($WC::c->{'config'}->{'encodings'}->{'server_console'}ne '');}}sub init_INPUT_CMD{if(defined$WC::c->{'request'}->{'params'}->{'cmd_query'}&&$WC::c->{'request'}->{'params'}->{'cmd_query'}ne ''){$WC::c->{'request'}->{'cmd'}=$WC::c->{'request'}->{'params'}->{'cmd_query'};
if($WC::c->{'request'}->{'cmd'}=~/^[ \t]{0,}([^ \t]+)[ \t]{0,1}(.*)$/){$WC::c->{'request'}->{'cmd_'}=$1;
$WC::c->{'request'}->{'cmd_params'}=$2;
&NL::String::str_trim(\$WC::c->{'request'}->{'cmd_params'});
@{$WC::c->{'request'}->{'cmd_params_arr'}}=split(/[ \t]+/,$WC::c->{'request'}->{'cmd_params'});}return 1;}return 0;}sub execute{return&_execute(defined$_[0]?$_[0]:'',defined$_[1]?$_[1]:'',\&WC::Encode::encode_from_CONSOLE_to_SYSTEM);}sub execute_encoding_WC{return&_execute(defined$_[0]?$_[0]:'',defined$_[1]?$_[1]:'',\&WC::Encode::encode_from_CONSOLE_to_INTERNAL);}sub _execute{my($in_CMD,$in_METHOD,$in_CALLBACK_CONVERT)=@_;
$in_METHOD='BACKTICKS' if(!defined$in_METHOD||$in_METHOD eq '');
my$result_HASH={'ID'=>1,'text'=>'','error'=>['','']};
if(!defined$in_CMD||$in_CMD eq ''){$result_HASH->{'ID'}=0;
$result_HASH->{'error'}=['Nothing to execute','Command for execution (ARG1) is empty'];}else{local$|=1;
if($in_METHOD eq 'BACKTICKS'){$result_HASH->{'text'}=`$in_CMD 2>&1`;}elsif($in_METHOD eq 'OPEN'){if(open(HANDLE_EXEC_CMD,$in_CMD.' 2>&1|')){while(<HANDLE_EXEC_CMD>){$result_HASH->{'text'}.=$_;}close(HANDLE_EXEC_CMD);}else{$result_HASH->{'ID'}=-1;
$result_HASH->{'error'}=["Unable to execute command '$in_CMD'",$!];}}&{$in_CALLBACK_CONVERT}(\$result_HASH->{'text'})if($result_HASH->{'text'}ne ''&&defined$in_CALLBACK_CONVERT);}return$result_HASH;}package WC::CGI;
use strict;
$WC::CGI::DATA={'DYNAMIC'=>{'POST_processed'=>0}};
sub init{&NL::CGI::init(\&_func_ENCODE,0);}sub _func_ENCODE{my($in_ref_val)=@_;
return&WC::Encode::encode_from_CGI($in_ref_val);}sub is_POST_processed{return($WC::CGI::DATA->{'DYNAMIC'}->{'POST_processed'})?1:0;}sub get_input{return&NL::CGI::get_input(@_);}sub get_input_from_GET{return&NL::CGI::get_input_from_GET(@_);}sub get_input_from_POST{return&NL::CGI::get_input_from_POST(@_);}sub get_input_from_POST_FILE{return&NL::CGI::get_input_from_POST_FILE(@_);}sub get_input_from_GET_SET{$WC::c->{'req'}->{'params'}=&get_input_from_GET(@_);}sub get_input_from_POST_UPDATE{return if($WC::CGI::DATA->{'DYNAMIC'}->{'POST_processed'});
my$ref_HASH_POST=&get_input_from_POST();
foreach(keys%{$ref_HASH_POST}){$WC::c->{'req'}->{'params'}->{$_}=$ref_HASH_POST->{$_}if(!defined$WC::c->{'req'}->{'params'}->{$_});}$WC::CGI::DATA->{'DYNAMIC'}->{'POST_processed'}=1;}package WC::Dir;
use strict;
$WC::Dir::DATA={'DYNAMIC'=>{'dir_current'=>'','dir_splitter'=>'','dir_splitter_extra'=>[]}};
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub init{&update_current_dir();
&update_dir_splitters();}sub update_dir_splitters{my@arr_splitters=&NL::Dir::get_dir_splitters();
$WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'}=$arr_splitters[0];
$WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter_extra'}=$arr_splitters[1];}sub update_current_dir{$WC::Dir::DATA->{'DYNAMIC'}->{'dir_current'}=&NL::Dir::get_current_dir();}sub get_current_dir{&update_current_dir()if($WC::Dir::DATA->{'DYNAMIC'}->{'dir_current'}eq '');
return$WC::Dir::DATA->{'DYNAMIC'}->{'dir_current'};}sub get_dir_splitter{&update_dir_splitters()if($WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'}eq '');
return$WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'};}sub get_dir_splitters{&update_dir_splitters()if($WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'}eq '');
return($WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'},$WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter_extra'});}sub change_dir{my$chdir_result=&NL::Dir::change_dir($_[0]);
&update_current_dir()if($chdir_result);
return$chdir_result;}sub change_dir_TO_CURRENT{&_error_reset();
if(defined$WC::c->{'req'}->{'params'}->{'STATE_dir_current'}&&$WC::c->{'req'}->{'params'}->{'STATE_dir_current'}ne ''){$WC::c->{'state'}->{'dir_current'}=$WC::c->{'req'}->{'params'}->{'STATE_dir_current'};}if(!&WC::Dir::change_dir($WC::c->{'state'}->{'dir_current'})){&_error_set("Unable change directory to '".(&NL::String::str_HTML_full($WC::c->{'state'}->{'dir_current'}))."'",'Please make sure that directory was not removed or renamed. <br />You can change current directory using &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'cd\'); return false" title="Click to paste at command input">cd</a>&quot; command.','WC_DIR_CD_CURRENT_UNABLE');
return 0;}return 1;}sub check_in{return&NL::Dir::check_in(defined$_[0]?$_[0]:'');}sub check_out{return&NL::Dir::check_out(defined$_[0]?$_[0]:'');}package WC::File;
use strict;
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub lock_init{&_error_reset();
my($in_DIR,$in_DONT_REMOVE_FILES)=@_;
$in_DONT_REMOVE_FILES=0 if(!defined$in_DONT_REMOVE_FILES);
if(!defined$in_DIR){&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' temp directory is not defined',"Uncorrect call of method 'WC::File::lock_init()'",'WC_FILE_LOCK_INIT_DIR_TMP_NOT_DEFINED');
return 0;}my$dir_TMP='';
if($in_DIR ne ''&&-d$in_DIR){$dir_TMP=$in_DIR;}if($dir_TMP ne ''){if(&NL::File::Lock::init($dir_TMP)){if(!$in_DONT_REMOVE_FILES){&NL::Dir::remove_old_files($dir_TMP,{'SECONDS_OLD'=>3600*24,'SKIP_FILES'=>['.htaccess','index.html']});}return 1;}else{&_error_set("Unable to initialize 'NL::File::Lock'",'Hm... that is strange...','FILE_INIT_TMP_NL_UNABLE');}}else{&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' temp directory &quot;<b>'.$in_DIR.'</b>&quot; does not exists','Are you shure that '.$WC::c->{'APP_SETTINGS'}->{'name'}.' temp directory has not been removed?','WC_FILE_LOCK_INIT_DIR_TMP_NOT_FOUND');}return 0;}sub get_size{my($file)=@_;
$file='' if(!defined$file);
my$size=&NL::File::get_size($file);
if($size>=0){return$size;}elsif($size==-1){&_error_set("WC::File::get_size(): Unable to get size of the file",'Filename is not defined or it is empty','WC_FILE_GET_SIZE_NO_FILENAME');}elsif($size==-2){&_error_set("WC::File::get_size(): Unable to get size of the file '$file'","File '$file' does not exists",'WC_FILE_GET_SIZE_NO_FILE_FOUND');}elsif($size==-3){&_error_set("WC::File::get_size(): Unable to get size of the file '$file'",'Information about file does not contain file size','WC_FILE_GET_SIZE_NO_SIZE_INFO');}else{&_error_set("WC::File::get_size(): Unable to get size of file '$file'");}return-1;}sub get_name{my($file)=@_;
return '' if(!defined$file);
my($main,$extra)=&WC::Dir::get_dir_splitters();
foreach my $splitter($main,@{$extra}){my$qms=quotemeta($splitter);
$file=~s/^.*[$qms]([^$qms]{0,})$/$1/;}return$file;}sub get_dir{my($file)=@_;
return '' if(!defined$file);
my($main,$extra)=&WC::Dir::get_dir_splitters();
foreach my $splitter($main,@{$extra}){my$qms=quotemeta($splitter);
$file=~s/(^.*)[$qms][^$qms]{0,}$/$1/;}return$file;}sub lock_read{return 1;}sub lock_write{return 1;}sub unlock{return&NL::File::Lock::unlock(@_);}sub save{&_error_reset();
my($in_config_file,$in_text,$in_settings)=@_;
$in_settings={}if(!defined$in_settings);
if(!defined$in_config_file||$in_config_file eq ''){&_error_set('WC::File::save(): File name is not specified','Incorrect call of function','WC_FILE_SAVE_NO_FILE_NAME');
return-1;}if(!defined$in_text){&_error_set('WC::File::save(): File DATA is not specified','Incorrect call of function','WC_FILE_SAVE_NO_FILE_DATA');
return-1;}if(!&lock_write($in_config_file,{'timeout'=>15,'time_sleep'=>0.1})){&_error_set("WC::File::save(): Unable to lock file '$in_config_file' for writing",'Please ensure that filename is correct and locking system is configured correctry','WC_FILE_SAVE_UNABLE_LOCK');
return-1;}else{if(!open(FH_CONFIG,'>'.$in_config_file)){&_error_set("WC::File::save(): Unable to open file '$in_config_file' for writing (file is successfully locked)",$!,'WC_FILE_SAVE_UNABLE_OPEN_BUT_LOCKED');
return 0;}else{binmode FH_CONFIG if(defined$in_settings->{'BINMODE'}&&$in_settings->{'BINMODE'});
print FH_CONFIG$in_text;
truncate(FH_CONFIG,tell FH_CONFIG);
close(FH_CONFIG);
&unlock($in_config_file);
chmod(oct($in_settings->{'CHMOD'}),$in_config_file)if(defined$in_settings->{'CHMOD'}&&$in_settings->{'CHMOD'}ne '');}}return 1;}package WC::Config::FILE;
package WC::Config;
use strict;
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub check_is_installed{if(defined$WC::c->{'config'}->{'file_config'}&&$WC::c->{'config'}->{'file_config'}ne ''){return&is_exists($WC::c->{'config'}->{'file_config'});}else{return-1;}}sub is_exists{my($in_config_file)=@_;
if(defined$in_config_file&&$in_config_file ne ''){return&NL::File::is_exists($in_config_file);}else{return-1;}}sub load{&_error_reset();
my($in_config_file,$in_str_hash_FROM,$in_ref_hash_TO)=@_;
if(!defined$in_config_file||$in_config_file eq ''){&_error_set("WC::Config::load(): Input paremeter ARG1 is not defiend","Incorrect call of 'WC::Config::load()'");
return-1;}else{if(!-f$in_config_file){&_error_set("WC::Config::load(): Config file '$in_config_file' not found",'','WC_CONFIG_LOAD_FILE_NOT_FOUND');
return 0;}else{if(!&WC::File::lock_read($in_config_file,{'timeout'=>10,'time_sleep'=>0.1})){&_error_set("WC::Config::load(): Unable to lock file '$in_config_file' for reading",'','WC_CONFIG_LOAD_FILE_UNABLE_LOCK');
return-1;}else{eval{require$in_config_file;};
&WC::File::unlock($in_config_file);
if($@){&_error_set('WC::Config::load(): Config syntax error',$@,'WC_CONFIG_LOAD_EVAL_ERROR');
return-1;}else{my$dir_temp=$in_ref_hash_TO->{'directorys'}->{'temp'};
my$dir_work=$in_ref_hash_TO->{'directorys'}->{'work'};
eval '&NL::Utils::hash_update($in_ref_hash_TO, '.$in_str_hash_FROM.') if defined '.$in_str_hash_FROM;
$in_ref_hash_TO->{'directorys'}->{'temp'}=$dir_temp;
$in_ref_hash_TO->{'directorys'}->{'work'}=$dir_work;
return 1;}}}}}sub save{&_error_reset();
my($in_FILE,$in_HASH_DATA,$in_PARAM_NAME,$in_CONFIG_NAME)=@_;
$in_CONFIG_NAME='_UNKNOWN_' if(!defined$in_CONFIG_NAME);
if(!defined$in_FILE||$in_FILE eq ''){&_error_set('WC::Config::save(): Incorrect call','Parameter 0 (config filename) is needed and can\'t be empty');}elsif(!defined$in_HASH_DATA){&_error_set('WC::Config::save(): Incorrect call','Parameter 1 (HASH with config data) is needed');}elsif(!defined$in_PARAM_NAME||$in_PARAM_NAME eq ''){&_error_set('WC::Config::save(): Incorrect call','Parameter 2 (config parameter name) is needed and can\'t be empty');}else{my$conf_text=&make_text($in_HASH_DATA,$in_PARAM_NAME,$in_CONFIG_NAME);
if($conf_text eq ''){&_error_set("WC::Config::save(): Unable to create config text for file '$in_FILE' (config name '".$in_CONFIG_NAME."')","Looks like incorret call of 'WC::Config::save()'");}else{my$result=&WC::File::save($in_FILE,$conf_text,{'CHMOD'=>$WC::CONST->{'CHMODS'}->{'CONFIGS'}});
if($result==1){return 1;}else{&_error_set(&WC::File::get_last_error_ARR());}}}return 0;}sub make_text{my($in_ref_hash_config,$in_config_param_name,$in_config_name)=@_;
my$conf_text='';
my$conf_text_hash=&NL::String::VAR_to_PERL($in_ref_hash_config,{'SPACES'=>1,'SORT'=>1});
if($conf_text_hash ne ''){$conf_text='#!/usr/bin/perl'."\n";
$conf_text.="# This is Web Console ".(($in_config_name ne '')?"'$in_config_name' ":'')."configuration file\n";
$conf_text.="# Web Console version: '".((defined$WC::CONST->{'VERSION'}->{'NUMBER'})?$WC::CONST->{'VERSION'}->{'NUMBER'}:'_UNKNOWN_')."'\n";
$conf_text.="# Edit this file manually is not recommended\n";
$conf_text.="#\n";
$conf_text.="# Web Console author: Kovalev Nick\n";
$conf_text.="# Web Console author's resume: http://resume.nickola.ru\n";
$conf_text.="#\n";
$conf_text.="# Web Console URL: http://www.web-console.org\n";
$conf_text.="# Last version of Web Console can be downloaded from: http://www.web-console.org/download/\n";
$conf_text.="# Web Console Group services: http://services.web-console.org\n";
$conf_text.="\n";
$conf_text.='if (!defined $WC::ENGINE_LOADED || !$WC::ENGINE_LOADED) { print "Content-type: text/html; charset=utf-8\n\n"; exit; }'."\n\n";
$conf_text.=$in_config_param_name.' = '.$conf_text_hash.";\n";
$conf_text.="\n1; #EOF";}return$conf_text;}package WC::Config::Main;
use strict;
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub IS_WEB_CONSOLE_INSTALLED{return&is_exists();}sub is_exists{if(defined$WC::c->{'config'}->{'files'}->{'config'}&&$WC::c->{'config'}->{'files'}->{'config'}ne ''){return&NL::File::is_exists($WC::c->{'config'}->{'files'}->{'config'});}else{return-1;}}sub load{&_error_reset();
if(!defined$WC::c->{'config'}->{'files'}->{'config'}||$WC::c->{'config'}->{'files'}->{'config'}eq ''){&_error_set('Main '.$WC::c->{'APP_SETTINGS'}->{'name'}.' config filename is not defined','Looks very strange, are you shure that '.$WC::c->{'APP_SETTINGS'}->{'name'}.' has not been modified?');
return-1;}my$result=&WC::Config::load($WC::c->{'config'}->{'files'}->{'config'},'$WC::Config::FILE::CONFIG_MAIN',$WC::c->{'config'});
if($result!=1){&_error_set("Unable to load config file '".$WC::c->{'config'}->{'files'}->{'config'}."'",&WC::Config::get_last_error_TEXT(),&WC::Config::get_last_error_ID());
if($result==0){return 0;}else{return-1;}}else{return 1;}}sub save{&_error_reset();
my($in_HASH_DATA)=@_;
if(!defined$WC::c->{'config'}->{'files'}->{'config'}||$WC::c->{'config'}->{'files'}->{'config'}eq ''){&_error_set('WC::Config::Main::save(): Unable to get config filename','Variable is not defined');}elsif(!defined$in_HASH_DATA){&_error_set('WC::Config::Main::save(): Incorrect call','Parameter 0 (HASH with config data) is needed');}else{my$conf_NAME='MAIN';
my$conf_PARAM_NAME='$WC::Config::FILE::CONFIG_MAIN';
my%config_NEW;
&NL::Utils::hash_clone(\%config_NEW,&get_variables_defaults());
&NL::Utils::hash_update(\%config_NEW,$in_HASH_DATA);
$config_NEW{'directorys'}={}if(!defined$config_NEW{'directorys'});
$config_NEW{'directorys'}->{'temp'}=$WC::c->{'config'}->{'directorys'}->{'temp'}if(!defined$config_NEW{'directorys'}->{'temp'}||$config_NEW{'directorys'}->{'temp'}eq '');
$config_NEW{'directorys'}->{'work'}=$WC::c->{'config'}->{'directorys'}->{'work'}if(!defined$config_NEW{'directorys'}->{'work'}||$config_NEW{'directorys'}->{'work'}eq '');
&NL::Parameter::remove(\%config_NEW,['encodings|internal','directorys_splitter','directorys|home','directorys|data','directorys|configs','directorys|plugins','directorys|plugins_configs','files']);
my$conf_text=&WC::Config::make_text(\%config_NEW,$conf_PARAM_NAME,$conf_NAME);
if($conf_text eq ''){&_error_set("WC::Config::Main::save(): Unable to create config text for file '".$WC::c->{'config'}->{'files'}->{'config'}."' (config name '".$conf_NAME."')","Looks like incorret call of 'WC::Config::Main::save()'");}else{my$result=&WC::File::save($WC::c->{'config'}->{'files'}->{'config'}.'',$conf_text,{'CHMOD'=>$WC::CONST->{'CHMODS'}->{'CONFIGS'}});
if($result==1){return 1;}else{&_error_set(&WC::File::get_last_error_ARR());}}}return 0;}sub get_variables_defaults{my$default_CONFIG_HASH={'encodings'=>{'editor_text'=>'','server_console'=>'','server_system'=>'','file_download'=>'','internal'=>'utf8'},'logon'=>{'javascript'=>'','show_welcome'=>1,'show_warnings'=>1},'directorys_splitter'=>'/','directorys'=>{},'files'=>{},'uploading'=>{'limit'=>50},'styles'=>{'console'=>{'font'=>{'color'=>'#bbbbbb','size'=>'10pt','family'=>'fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif'}}}};
$default_CONFIG_HASH->{'directorys_splitter'}=&WC::Dir::get_dir_splitter();
$default_CONFIG_HASH->{'directorys'}->{'home'}=$WC::c->{'APP_SETTINGS'}->{'dir_path'};
$default_CONFIG_HASH->{'directorys'}->{'data'}=$default_CONFIG_HASH->{'directorys'}->{'home'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_data';
$default_CONFIG_HASH->{'directorys'}->{'work'}=$default_CONFIG_HASH->{'directorys'}->{'home'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_work';
$default_CONFIG_HASH->{'directorys'}->{'configs'}=$default_CONFIG_HASH->{'directorys'}->{'data'}.$default_CONFIG_HASH->{'directorys_splitter'}.'configs';
$default_CONFIG_HASH->{'directorys'}->{'plugins'}=$default_CONFIG_HASH->{'directorys'}->{'data'}.$default_CONFIG_HASH->{'directorys_splitter'}.'plugins';
$default_CONFIG_HASH->{'directorys'}->{'plugins_configs'}=$default_CONFIG_HASH->{'directorys'}->{'plugins'}.$default_CONFIG_HASH->{'directorys_splitter'}.'configs';
$default_CONFIG_HASH->{'directorys'}->{'temp'}=$default_CONFIG_HASH->{'directorys'}->{'data'}.$default_CONFIG_HASH->{'directorys_splitter'}.'temp';
$default_CONFIG_HASH->{'files'}->{'config'}=$default_CONFIG_HASH->{'directorys'}->{'configs'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_config.pl';
$default_CONFIG_HASH->{'files'}->{'users'}=$default_CONFIG_HASH->{'directorys'}->{'configs'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_users.pl';
$default_CONFIG_HASH->{'files'}->{'.HTACCESS'}=$default_CONFIG_HASH->{'directorys'}->{'home'}.$default_CONFIG_HASH->{'directorys_splitter'}.'.htaccess';
return$default_CONFIG_HASH;}sub init_variables_defaults{$WC::c->{'config'}=&get_variables_defaults();}package WC::Users;
use strict;
$WC::Users::DATA={'DYNAMIC'=>{'LOADED_DB'=>{}}};
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub IS_WEB_CONSOLE_INSTALLED{if(defined$WC::c->{'config'}->{'files'}->{'users'}&&$WC::c->{'config'}->{'files'}->{'users'}ne ''){return&WC::Config::is_exists($WC::c->{'config'}->{'files'}->{'users'});}else{return-1;}}sub init{&_error_reset();
if(!defined$WC::c->{'config'}->{'files'}->{'users'}||$WC::c->{'config'}->{'files'}->{'users'}eq ''){&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' Users DB file name is not defined','Looks very strange, are you shure that '.$WC::c->{'APP_SETTINGS'}->{'name'}.' has not been modified?');
return-1;}my$result=&WC::Config::load($WC::c->{'config'}->{'files'}->{'users'},'$WC::Config::FILE::USERS_DB',$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'});
if($result!=1){&_error_set("Unable to load Users DB file '".$WC::c->{'config'}->{'files'}->{'users'}."'",&WC::Config::get_last_error_TEXT(),&WC::Config::get_last_error_ID());
if($result==0){return 0;}else{return-1;}}else{return 1;}}sub get_users_list{if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}&&defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}){return$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'};}else{return{};}}sub get_groups_list{if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}&&defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'groups'}){return$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'groups'};}else{return{};}}sub save_file{&_error_reset();
my($in_HASH_DATA)=@_;
if(!defined$in_HASH_DATA){&_error_set('WC::Users::save_file(): Incorrect call, parameter is needed');}elsif(!defined$WC::c->{'config'}->{'files'}->{'users'}){&_error_set("WC::Users::save_file(): Users DB file is not defined");}else{if(&WC::Config::save($WC::c->{'config'}->{'files'}->{'users'},$in_HASH_DATA,'$WC::Config::FILE::USERS_DB','USERS DB')==1){return 1;}else{&_error_set(&WC::Config::get_last_error_TEXT());}}return 0;}sub create{&_error_reset();
my($in_HASH_DATA)=@_;
if(!defined$in_HASH_DATA){&_error_set('WC::Users::create(): Incorrect call, parameter is needed');}else{my$check_PARAMETERS={'login'=>{'name'=>'Login','needed'=>1,'can_be_empty'=>0},'password'=>{'name'=>'Password','needed'=>1,'can_be_empty'=>0},'e-mail'=>{'name'=>'E-mail','needed'=>1,,'can_be_empty'=>0,'func_CHECK'=>\&NL::Parameter::FUNC_CHECK_email}};
my$check_RESULT=&NL::Parameter::check($in_HASH_DATA,$check_PARAMETERS);
if(!$check_RESULT->{'ID'}){&_error_set($check_RESULT->{'ERROR_MESSAGE'});}else{if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}&&defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}){if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_HASH_DATA->{'login'}}){&_error_set("User with that login ('".$in_HASH_DATA->{'login'}."') is already registred");}else{my$user_login=$in_HASH_DATA->{'login'};
delete$in_HASH_DATA->{'login'};
$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$user_login}=$in_HASH_DATA;
if(&save_file($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'})==1){return 1;}else{&_error_set(&get_last_error_TEXT());}}}else{&_error_set('ERROR: Users DB is not loaded');}}}return 0;}sub remove{&_error_reset();
my($in_login)=@_;
if(!defined$in_login){&_error_set('WC::Users::remove(): Incorrect call, parameter 1 is needed');}else{if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}&&defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}){if(!defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}){&_error_set("User ('$in_login') is not registred");}else{delete$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login};
if(&save_file($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'})==1){return 1;}else{&_error_set(&get_last_error_TEXT());}}}else{&_error_set('ERROR: Users DB is not loaded');}}return 0;}sub modify{&_error_reset();
my($in_login,$in_HASH_DATA)=@_;
if(!defined$in_login){&_error_set('WC::Users::create(): Incorrect call, parameter 1 is needed');}if(!defined$in_HASH_DATA){&_error_set('WC::Users::create(): Incorrect call, parameter 2 is needed');}else{my$check_PARAMETERS={'login'=>{'name'=>'Login','needed'=>0,'can_be_empty'=>0},'password'=>{'name'=>'Password','needed'=>0,'can_be_empty'=>0},'e-mail'=>{'name'=>'E-mail','needed'=>0,,'can_be_empty'=>0,'func_CHECK'=>\&NL::Parameter::FUNC_CHECK_email}};
my$check_RESULT=&NL::Parameter::check($in_HASH_DATA,$check_PARAMETERS);
if(!$check_RESULT->{'ID'}){&_error_set($check_RESULT->{'ERROR_MESSAGE'});}else{if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}&&defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}){if(!defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}){&_error_set("User ('$in_login') is not registred");}else{my$user_login=$in_login;
if(defined$in_HASH_DATA->{'login'}){if($in_HASH_DATA->{'login'}ne$in_login){if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_HASH_DATA->{'login'}}){&_error_set("User with login ('".$in_HASH_DATA->{'login'}."') is already registred, if you need to set that login for user - please remove existing user with same login before");
return 0;}else{$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_HASH_DATA->{'login'}}=$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login};
delete$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login};
$user_login=$in_HASH_DATA->{'login'};}}delete$in_HASH_DATA->{'login'};}if(!defined$in_HASH_DATA->{'password'}){if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$user_login}->{'password'}){$in_HASH_DATA->{'password'}=$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$user_login}->{'password'};}}$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$user_login}=$in_HASH_DATA;
if(&save_file($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'})==1){return 1;}else{&_error_set(&get_last_error_TEXT());}}}else{&_error_set('ERROR: Users DB is not loaded');}}}return 0;}sub authenticate{&_error_reset();
my($response_TYPE)=@_;
$response_TYPE=$WC::c->{'response'}->{'type'}if(!defined$response_TYPE);
if(defined$WC::c->{'req'}->{'params'}->{'user_login'}&&$WC::c->{'req'}->{'params'}->{'user_login'}ne ''&&defined$WC::c->{'req'}->{'params'}->{'user_password'}&&$WC::c->{'req'}->{'params'}->{'user_password'}ne ''){my$result_AUTH=0;
$result_AUTH=&_authenticate_LP($WC::c->{'req'}->{'params'}->{'user_login'},$WC::c->{'req'}->{'params'}->{'user_password'});
if($result_AUTH==1){return 1;}if($result_AUTH==0){if($response_TYPE eq 'HTML'){my$stash={'user_login'=>&NL::String::str_HTML_value($WC::c->{'req'}->{'params'}->{'user_login'}),'main_info'=>'<div class="logon-INCORRECT">Incorrect login/password</div><div class="logon-TODO">Please try again</div>'};
&WC::Response::show_HTML_PAGE('html_logon',$stash);}elsif($response_TYPE eq 'AJAX'){&WC::CORE::die_info_AJAX('Incorrect login/password','Entered login/password is incorrect, are you hacker?');}}else{my@arr_ERROR=('Unable to authenticate',&WC::Users::get_last_error_TEXT(),&WC::Users::get_last_error_ID());
if($response_TYPE eq 'HTML'){&WC::CORE::die_info_HTML(@arr_ERROR);}elsif($response_TYPE eq 'AJAX'){&WC::CORE::die_info_AJAX(@arr_ERROR);}}}else{my@arr_ERROR=('Login or password is not defined','That is incorrect '.$WC::c->{'APP_SETTINGS'}->{'name'}.' call, are you hacker?','WC_USERS_AUTHENTICATE_NO_LOGIN_OR_PASSWORD');
if($response_TYPE eq 'HTML'){&WC::CORE::die_info_HTML(@arr_ERROR);}elsif($response_TYPE eq 'AJAX'){&WC::CORE::die_info_AJAX(@arr_ERROR);}}return 0;}sub _authenticate_LP{&_error_reset();
my($in_login,$in_password)=@_;
my$return_code=1;
if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}&&defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}){if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}){if(defined$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}->{'password'}){if($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}->{'password'}eq$in_password){$WC::c->{'user'}=$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login};
$return_code=1;}else{&_error_set('Incorrect password');
$return_code=0;}}else{&_error_set("User don't have password at Users DB");
$return_code=0;}}else{&_error_set('Incorrect login');
$return_code=0;}}else{&_error_set('Users DB is not loaded','','WC_USERS_AUTHENTICATE_DB_NOT_LOADED');
$return_code=-1;}return$return_code;}package WC::Install;
use strict;
$WC::Install::DATA={'CONST'=>{'MAX_PATH_LENGTH_TO_SHOW'=>55},'DYNAMIC'=>{}};
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub CHECK_IS_WEB_CONSOLE_INSTALLED{my$result_CONFIG=&WC::Config::Main::IS_WEB_CONSOLE_INSTALLED();
my$result_USERS=&WC::Users::IS_WEB_CONSOLE_INSTALLED();
if($result_CONFIG==1){if($result_USERS==1){return 1;}elsif($result_USERS==0){&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' users DB not found',$WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object exists, but users DB does not exists','INIT_CONFIG_OK_USERS_NO');}else{&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' users DB checking error',$WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object exists, but unable to check if users DB is exists','INIT_CONFIG_OK_USERS_BAD');}}elsif($result_CONFIG==0){if($result_USERS==0){return 0;}elsif($result_USERS==1){&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object not found','No '.$WC::c->{'APP_SETTINGS'}->{'name'}.' configuration file exists, but users DB is exists','INIT_CONFIG_NO_USERS_OK');}else{&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object not found','No '.$WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object exists and unable to check if users DB is exists','INIT_CONFIG_NO_USERS_BAD');}}else{if($result_USERS==0){&_error_set('Unable to check if configuration file is exists','Unable to check if configuration file is exists, but users DB not found','INIT_CONFIG_BAD_USERS_NO');}elsif($result_USERS==1){&_error_set('Unable to check if configuration file is exists','Unable to check if configuration file is exists, but users DB is exists','INIT_CONFIG_BAD_USERS_OK');}else{&_error_set('Unable to check if configuration file is exists','Unable to check if configuration file is exists and unable to check if users DB is exists','INIT_CONFIG_BAD_USERS_BAD');}}return-1;}sub make_DATA_htaccess_HEADER{my($in_TYPE)=@_;
my$TEXT='';
$TEXT.="# This is Web Console $in_TYPE '.htaccess' file\n";
$TEXT.="# Web Console version: '".(defined$WC::CONST->{'VERSION'}->{'NUMBER'}?$WC::CONST->{'VERSION'}->{'NUMBER'}:'_UNKNOWN_')."'\n";
$TEXT.="# Edit this file manually is not recommended\n";
$TEXT.="#\n";
$TEXT.="# Web Console author: Kovalev Nick\n";
$TEXT.="# Web Console author's resume: http://resume.nickola.ru\n";
$TEXT.="#\n";
$TEXT.="# Web Console URL: http://www.web-console.org\n";
$TEXT.="# Last version of Web Console can be downloaded from: http://www.web-console.org/download/\n";
$TEXT.="# Web Console Group services: http://services.web-console.org\n";
$TEXT.="\n";
return$TEXT;}sub make_DATA_htaccess_FOOTER{my($in_TYPE)=@_;
my$TEXT='';
$TEXT.="\n";
$TEXT.='# ERRORDOCUMENT'."\n";
$TEXT.="ErrorDocument 401 \"<html><title>401: Authorization Required</title><body bgcolor='#000000' text='#bbbbbb'><font style='font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;'>401: Authorization Required</font></body></html>\n";
$TEXT.="ErrorDocument 403 \"<html><title>403: Access Forbidden</title><body bgcolor='#000000' text='#bbbbbb'><font style='font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;'>403: Access Forbidden</font></body></html><!-- IE FIX: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->\n";
$TEXT.="ErrorDocument 404 \"<html><title>404: File not found</title><body bgcolor='#000000' text='#bbbbbb'><font style='font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;'>404: File not found</font></body></html><!-- IE FIX: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->\n";
$TEXT.="ErrorDocument 500 \"500: Internal Server Error\n";
return$TEXT;}sub make_DATA_htaccess{my$file_name_RE=$WC::c->{'APP_SETTINGS'}->{'file_name'};
$file_name_RE=~s/([\\|\.|\-])/\\$1/g;
my$TEXT=&make_DATA_htaccess_HEADER('MAIN');
$TEXT.='Options -Indexes +ExecCGI'."\n";
$TEXT.='# Allow ONLY: "" | "index.html" | "'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'"'."\n";
$TEXT.='<IfModule mod_rewrite.c>'."\n";
$TEXT.='	Options +FollowSymLinks'."\n";
$TEXT.='	RewriteEngine On'."\n";
$TEXT.='	RewriteRule ^/?$ %{REQUEST_URI}'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.' [L]'."\n";
$TEXT.='	RewriteRule !^(/|index\.html|'.$file_name_RE.')$ - [F]'."\n";
$TEXT.='</IfModule>'."\n";
$TEXT.='<IfModule !mod_rewrite.c>'."\n";
$TEXT.='	# DROP ALL'."\n";
$TEXT.='	Order Deny,Allow'."\n";
$TEXT.='	Deny from all'."\n";
$TEXT.='	<Files "'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'">'."\n";
$TEXT.='		Order Deny,Allow'."\n";
$TEXT.='		Allow from all'."\n";
$TEXT.='	</Files>'."\n";
$TEXT.='	<Files "index.html">'."\n";
$TEXT.='		Order Deny,Allow'."\n";
$TEXT.='		Allow from all'."\n";
$TEXT.='	</Files> '."\n";
$TEXT.='	<Files "">'."\n";
$TEXT.='		Order Deny,Allow'."\n";
$TEXT.='		Allow from all'."\n";
$TEXT.='	</Files>'."\n";
$TEXT.='</IfModule> '."\n";
$TEXT.=&make_DATA_htaccess_FOOTER();
return$TEXT;}sub make_DATA_htaccess_SUBDIR{my$file_name_RE=$WC::c->{'APP_SETTINGS'}->{'file_name'};
$file_name_RE=~s/([\\|\.|\-])/\\$1/g;
my$TEXT=&make_DATA_htaccess_HEADER('SUBDIRECTORYS');
$TEXT.="<Files *>\n";
$TEXT.="	Order Allow,Deny\n";
$TEXT.="	Deny from All\n";
$TEXT.="</Files>\n";
$TEXT.=&make_DATA_htaccess_FOOTER();
return$TEXT;}sub make_DATA_index{my$TEXT='';
$TEXT.='<?xml version="1.0" encoding="UTF-8"?>'."\n";
$TEXT.='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'."\n";
$TEXT.='<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">'."\n";
$TEXT.='<head>'."\n";
$TEXT.='	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'."\n";
$TEXT.='	<meta name="author" content="Nickolay Kovalev | http://resume.nickola.ru" />'."\n";
$TEXT.='	<meta name="robots" content="NONE" />'."\n";
$TEXT.='	<meta http-equiv="refresh" content="0; url='.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'" />'."\n";
$TEXT.='	<title>Loading...</title>'."\n";
$TEXT.='	<style>'."\n";
$TEXT.='		* {'."\n";
$TEXT.='			background-color: #000; color: #23d500; margin: 0; padding: 0;'."\n";
$TEXT.='			font-weight: normal; font-family: verdana, helvetica, arial, sans-serif; font-size: 12px;'."\n";
$TEXT.='		} '."\n";
$TEXT.='		a, a:visited, a:hover { background-color: #000; color: #bbbbbb; text-decoration: underline; }'."\n";
$TEXT.='		html, body { margin: 0; padding: 0; height: 100%; }'."\n";
$TEXT.='		body { margin: 7px 12px; }'."\n";
$TEXT.='		.wait { margin: 2px 0 0 0; color: #1196cb; }'."\n";
$TEXT.='		.wait a, .wait a:visited, .wait a:hover { color: #1196cb; }'."\n";
$TEXT.='	</style>'."\n";
$TEXT.='	<script type="text/javascript">'."\n";
$TEXT.='	<!--'."\n";
$TEXT.='	location.href=\''.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'\';'."\n";
$TEXT.='	//-->'."\n";
$TEXT.='	</script>'."\n";
$TEXT.='</head>'."\n";
$TEXT.='<body>Loading...<div class="wait">If you are waiting too long &mdash; <a href="'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'">click here</a>.</div></body>'."\n";
$TEXT.='</html>'."\n";
return$TEXT;}sub INIT_DATA_TO_CREATE{my$ref_hash_TEST={'test_name'=>'test_value'};
$WC::Install::DATA->{'DYNAMIC'}->{'TO_CREATE'}=[{'id'=>'file_index_home','path'=>$WC::c->{'config'}->{'directorys'}->{'home'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html','DATA'=>'<!-- [PERMISSIONS TEST] -->'},{'id'=>'dir_data','path'=>$WC::c->{'config'}->{'directorys'}->{'data'}},{'id'=>'file_index_data','path'=>$WC::c->{'config'}->{'directorys'}->{'data'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html','DATA'=>''},{'id'=>'file_htaccess_data','path'=>$WC::c->{'config'}->{'directorys'}->{'data'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess','DATA'=>&make_DATA_htaccess_SUBDIR()},{'id'=>'dir_temp','path'=>$WC::c->{'config'}->{'directorys'}->{'temp'}},{'id'=>'file_index_temp','path'=>$WC::c->{'config'}->{'directorys'}->{'temp'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html','DATA'=>''},{'id'=>'file_htaccess_temp','path'=>$WC::c->{'config'}->{'directorys'}->{'temp'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess','DATA'=>&make_DATA_htaccess_SUBDIR()},{'id'=>'dir_configs','path'=>$WC::c->{'config'}->{'directorys'}->{'configs'}},{'id'=>'file_index_configs','path'=>$WC::c->{'config'}->{'directorys'}->{'configs'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html','DATA'=>''},{'id'=>'file_htaccess_configs','path'=>$WC::c->{'config'}->{'directorys'}->{'configs'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess','DATA'=>&make_DATA_htaccess_SUBDIR()},{'id'=>'file_config','path'=>$WC::c->{'config'}->{'files'}->{'config'},'config_HASH'=>$ref_hash_TEST,'config_PARAM_NAME'=>'$WC::Config::FILE::CONFIG_MAIN','config_NAME'=>'MAIN (PERMISSIONS TEST)'},{'id'=>'file_users','path'=>$WC::c->{'config'}->{'files'}->{'users'},'config_HASH'=>$ref_hash_TEST,'config_PARAM_NAME'=>'$WC::Config::FILE::USERS_DB','config_NAME'=>'USERS DB (PERMISSIONS TEST)'},{'id'=>'dir_work','path'=>$WC::c->{'config'}->{'directorys'}->{'work'}},{'id'=>'file_index_work','path'=>$WC::c->{'config'}->{'directorys'}->{'work'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html','DATA'=>''},{'id'=>'file_htaccess_work','path'=>$WC::c->{'config'}->{'directorys'}->{'work'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess','DATA'=>&make_DATA_htaccess_SUBDIR()},{'id'=>'file_htaccess','path'=>$WC::c->{'config'}->{'files'}->{'.HTACCESS'},'DATA'=>'[PERMISSIONS TEST]','CHMOD'=>$WC::CONST->{'CHMODS'}->{'.HTACCESS'}},];}sub start{my$reqPARAMS=$WC::c->{'request'}->{'params'};
my@parameters_ERRORS=();
my$is_make_DEFAULT=1;
my$HTML_PAGE_TYPE='html_install';
my$hash_TO_HTML={};
my$hash_TO_SAVE={};
if(defined$reqPARAMS->{'q_action'}&&$reqPARAMS->{'q_action'}ne ''){if($reqPARAMS->{'q_action'}eq 'install'){my@arr_NEEDED=({'user_login'=>'Login'},{'user_password'=>'Password'},{'user_email'=>'E-mail'});
foreach my $elem(@arr_NEEDED){foreach(keys%{$elem}){if(!defined$reqPARAMS->{$_}||$reqPARAMS->{$_}eq ''){push@parameters_ERRORS,{'TYPE'=>'ERROR','variable'=>$elem->{$_},'html_element'=>'_'.$_.'_MAIN','message'=>"can't be empty"};}else{$hash_TO_SAVE->{$_}=$reqPARAMS->{$_};}}}if(defined$hash_TO_SAVE->{'user_email'}){&NL::String::str_trim(\$hash_TO_SAVE->{'user_email'});
my$hash_CHECK_EMAIL=&NL::Parameter::FUNC_CHECK_email($hash_TO_SAVE->{'user_email'});
if(!$hash_CHECK_EMAIL->{'ID'}){push@parameters_ERRORS,{'TYPE'=>'ERROR','variable'=>'E-mail','html_element'=>'_user_email_MAIN','message'=>'is incorrect'};}}if(scalar@parameters_ERRORS>0){my$report_PARAMETERS=&WC::HTML::Report::make_REPORT_PARAMETERS(\@parameters_ERRORS);
$hash_TO_HTML->{'main_info'}=$report_PARAMETERS->{'TEXT'};
foreach('user_login','user_email','encoding_SERVER_CONSOLE','encoding_SERVER_SYSTEM','encoding_EDITOR_TEXT'){if(defined$reqPARAMS->{$_}&&$reqPARAMS->{$_}!~/^[ \t\n\r]{0,}$/){$hash_TO_HTML->{$_}=&NL::String::str_HTML_value($reqPARAMS->{$_});}}if(defined$hash_TO_HTML->{'encoding_SERVER_CONSOLE'}||defined$hash_TO_HTML->{'encoding_SERVER_SYSTEM'}||defined$hash_TO_HTML->{'encoding_EDITOR_TEXT'}){$hash_TO_HTML->{'ENCODE_AREA_SHOW'}=1;}}else{foreach('encoding_SERVER_CONSOLE','encoding_SERVER_SYSTEM','encoding_EDITOR_TEXT'){if(defined$reqPARAMS->{$_}&&$reqPARAMS->{$_}!~/^[ \t\n\r]{0,}$/){$hash_TO_SAVE->{$_}=$reqPARAMS->{$_};}}my$saveRESULTS=&MAKE_INSTALL($hash_TO_SAVE);
if(!$saveRESULTS->{'ID'}){my$report=&WC::HTML::Report::make_REPORT_INSTALL($saveRESULTS->{'ERRORS'});
$hash_TO_HTML->{'PAGE_ACTION'}='ERROR';
$hash_TO_HTML->{'main_info'}=$report->{'TEXT'};}else{$HTML_PAGE_TYPE='html_installed';}}$is_make_DEFAULT=0;
&set_ENCODE_INFO($hash_TO_HTML)if($HTML_PAGE_TYPE ne 'html_installed');
&WC::Response::show_HTML_PAGE($HTML_PAGE_TYPE,$hash_TO_HTML);}}if($is_make_DEFAULT){&WC::Config::Main::init_variables_defaults();
&INIT_DATA_TO_CREATE();
my$testRESULTS=&MAKE_ALL($WC::Install::DATA->{'DYNAMIC'}->{'TO_CREATE'},{'IS_TESTING'=>1});
if(!$testRESULTS->{'ID'}){my$report=&WC::HTML::Report::make_REPORT_INSTALL($testRESULTS->{'ERRORS'});
$hash_TO_HTML->{'PAGE_ACTION'}='ERROR';
$hash_TO_HTML->{'main_info'}=$report->{'TEXT'};}else{&set_ENCODE_INFO($hash_TO_HTML);}&WC::Response::show_HTML_PAGE($HTML_PAGE_TYPE,$hash_TO_HTML);}}sub set_ENCODE_INFO{my($hash_TO_HTML)=@_;
my$HTML_ENCODE_PM_MESSAGE='';
if(!$WC::Encode::ENCODE_ON){$hash_TO_HTML->{'ENCODE_ON'}=0;
my$error_HTML=$WC::Encode::ENCODE_ERROR;
$error_HTML=&NL::String::fix_width($error_HTML,80);
&NL::String::str_HTML_value(\$error_HTML);
$error_HTML=~s/\n/<br \/>/g;
$hash_TO_HTML->{'ENCODE_ERROR'}= <<HTML_EOF;
		<table id="block-encoding-WARNING"><tr><td>
			<div class="encoding-WARNING-title">*** WARNING:</div>
			<div class="encoding-WARNING-main">
				ENCODINGS CONVERSION FEATURE WILL BE DISABLED.<br />
				Unable to load 'Encode.pm' Perl module, that module is needed for encodings conversion.<br />
				You can download that Perl module from CPAN: <a class="link-warning" href="http://search.cpan.org/~dankogai/Encode/Encode.pm" target="_blank">http://search.cpan.org/~dankogai/Encode/Encode.pm</a>
				<div class="encoding-WARNING-main-info">Additional information:</div>
				<div class="encoding-WARNING-main-info-DIV">$error_HTML</div>
			</div>
		</td></tr></table>
HTML_EOF
}else{$hash_TO_HTML->{'ENCODE_ENCODING'}='';
foreach(@{$WC::Internal::Data::Settings::ENCODINGS_LIST}){$hash_TO_HTML->{'ENCODE_ENCODING'}.=", " if($hash_TO_HTML->{'ENCODE_ENCODING'}ne '');
$hash_TO_HTML->{'ENCODE_ENCODING'}.='<a class="link" href="#" onclick="WC.Other.paste_at_active_INPUT(this, \''.$_.'\'); return false" title="Click to paste at active (or last active) encodings input">'.$_.'</a>';}}}sub MAKE_INSTALL{my($hash_TO_SAVE)=@_;
&WC::Config::Main::init_variables_defaults();
&INIT_DATA_TO_CREATE();
my$save_USERS={'users'=>{$hash_TO_SAVE->{'user_login'}=>{'group'=>'admin','password'=>$hash_TO_SAVE->{'user_password'},'e-mail'=>&NL::String::str_trim($hash_TO_SAVE->{'user_email'})}},'groups'=>{'admin'=>{},'user'=>{}}};
my$save_CONFIG=$WC::c->{'config'};
$save_CONFIG->{'encodings'}->{'server_console'}=&NL::String::str_trim($hash_TO_SAVE->{'encoding_SERVER_CONSOLE'})if(defined$hash_TO_SAVE->{'encoding_SERVER_CONSOLE'});
$save_CONFIG->{'encodings'}->{'server_system'}=&NL::String::str_trim($hash_TO_SAVE->{'encoding_SERVER_SYSTEM'})if(defined$hash_TO_SAVE->{'encoding_SERVER_SYSTEM'});
$save_CONFIG->{'encodings'}->{'editor_text'}=&NL::String::str_trim($hash_TO_SAVE->{'encoding_EDITOR_TEXT'})if(defined$hash_TO_SAVE->{'encoding_EDITOR_TEXT'});
my$hash_ACTIONS=$WC::Install::DATA->{'DYNAMIC'}->{'TO_CREATE'};
foreach(@{$hash_ACTIONS}){if(defined$_->{'id'}){if($_->{'id'}eq 'file_users'){$_->{'config_HASH'}=$save_USERS;
$_->{'config_NAME'}='USERS DB';}elsif($_->{'id'}eq 'file_config'){$_->{'config_HASH'}=$save_CONFIG;
$_->{'config_NAME'}='MAIN';}elsif($_->{'id'}eq 'file_htaccess'){$_->{'DATA'}=&make_DATA_htaccess();}elsif($_->{'id'}eq 'file_index_home'){$_->{'DATA'}=&make_DATA_index();}}}return&MAKE_ALL($hash_ACTIONS);}sub MAKE_ALL{my($ref_DATA,$is_SETTINGS)=@_;
$is_SETTINGS={}if(!defined$is_SETTINGS);
$is_SETTINGS->{'IS_TESTING'}=0 if(!defined$is_SETTINGS->{'IS_TESTING'});
my$result_ERRORS=[];
my$result_RM=[];
foreach my $obj(@{$ref_DATA}){if($obj->{'id'}=~/^dir_/){my$dir_path=$obj->{'path'};
if(-d$dir_path){$dir_path=&NL::String::get_right($dir_path,$WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'},1);
push@{$result_ERRORS},{'TYPE'=>'ERROR','id'=>'INSTALL_DIRECTORY_EXISTS','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}." has find a directory that should not exists\n(directory '$dir_path').",'info'=>'Try to remove that directory - then '.$WC::c->{'APP_SETTINGS'}->{'name'}.' can be installed.'};
last;}else{if(!mkdir($dir_path)){$dir_path=&NL::String::get_right($dir_path,$WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'},1);
push@{$result_ERRORS},{'TYPE'=>'ERROR','id'=>'INSTALL_DIRECTORY_UNABLE_CREATE','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to create directory:\n'$dir_path'",'info'=>$!};
last;}else{push@{$result_RM},{'type'=>'dir','path'=>$dir_path};}}}elsif($obj->{'id'}=~/file_/){my$file_path=$obj->{'path'};
if(-f$file_path){$file_path=&NL::String::get_right($file_path,$WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'},1);
push@{$result_ERRORS},{'TYPE'=>'ERROR','id'=>'INSTALL_FILE_EXISTS','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}." has find a file that should not exists\n(file '$file_path').",'info'=>'Try to remove that file - then '.$WC::c->{'APP_SETTINGS'}->{'name'}.' can be installed.'};
last;}else{my$isOK=0;
my$err_info='';
if(defined$obj->{'config_HASH'}){if($obj->{'id'}eq 'file_config'){if(&WC::Config::Main::save($obj->{'config_HASH'})==1){$isOK=1;}else{$err_info=&WC::Config::Main::get_last_error_TEXT();}}else{if(&WC::Config::save($file_path,$obj->{'config_HASH'},$obj->{'config_PARAM_NAME'},$obj->{'config_NAME'})==1){$isOK=1;}else{$err_info=&WC::Config::get_last_error_TEXT();}}}elsif(defined$obj->{'DATA'}){if(&WC::File::save($file_path,$obj->{'DATA'},{'CHMOD'=>(defined$obj->{'CHMOD'})?$obj->{'CHMOD'}:''})==1){$isOK=1;}else{$err_info=&WC::File::get_last_error_TEXT();}}if(!$isOK){$file_path=&NL::String::get_right($file_path,$WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'},1);
push@{$result_ERRORS},{'TYPE'=>'ERROR','id'=>'INSTALL_FILE_UNABLE_CREATE','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to create file:\n'$file_path'",'info'=>$err_info};
last;}else{push@{$result_RM},{'type'=>'file','path'=>$file_path};}}}}if($is_SETTINGS->{'IS_TESTING'}||scalar@{$result_ERRORS}>0){foreach my $obj_RM(reverse@{$result_RM}){if($obj_RM->{'type'}eq 'file'){if(unlink($obj_RM->{'path'})<=0){$obj_RM->{'path'}=&NL::String::get_right($obj_RM->{'path'},$WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'},1);
push@{$result_ERRORS},{'TYPE'=>'ERROR','id'=>'INSTALL_FILE_UNABLE_DELETE','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to delete file:\n'".$obj_RM->{'path'}."'",'info'=>$!};}}elsif($obj_RM->{'type'}eq 'dir'){if(!rmdir($obj_RM->{'path'})){$obj_RM->{'path'}=&NL::String::get_right($obj_RM->{'path'},$WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'},1);
push@{$result_ERRORS},{'TYPE'=>'ERROR','id'=>'INSTALL_DIRECTORY_UNABLE_DELETE','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to delete directory:\n'".$obj_RM->{'path'}."'",'info'=>$!};}}}}return{'ID'=>(scalar@{$result_ERRORS}>0)?0:1,'ERRORS'=>$result_ERRORS};}package WC::Response;
use strict;
sub print_HTTP_HEADER{foreach(@{$WC::CONST->{'HTTP_EXTRA_HEADERS'}}){print$_."\r\n" if($_!~/^\s{0,}$/);}print"Content-type: text/html; charset=utf-8\r\n";
foreach(@_){print$_."\r\n" if($_!~/^\s{0,}$/);}print"\r\n";}sub show_HTML_PAGE{my($in_PAGE_ID,$in_STASH)=@_;
$in_PAGE_ID='' if(!defined$in_PAGE_ID);
$in_STASH={}if(!defined$in_STASH);
&print_HTTP_HEADER();
&WC::HTML::show_page($in_PAGE_ID,$in_STASH);}sub show_AJAX_RESPONSE{return&WC::AJAX::show_response(@_);}sub show_AJAX_RESPONSE_NO_TEXT_ENCODE{return&WC::AJAX::show_response_NO_TEXT_ENCODE(@_);}sub show_error(){if($WC::c->{'res'}->{'type'}eq 'HTML'){&show_error_HTML(@_);}elsif($WC::c->{'res'}->{'type'}eq 'AJAX'){&show_error_AJAX(@_);}else{&show_error_TEXT(@_);}}sub show_error_HTML(){&_print_MESSAGE('HTML','ERROR',1,@_);}sub show_error_AJAX(){&_print_MESSAGE('AJAX','ERROR',1,@_);}sub show_error_TEXT(){&_print_MESSAGE('TEXT','ERROR',1,@_);}sub show_error_no_header(){if($WC::c->{'res'}->{'type'}eq 'HTML'){&show_error_HTML_no_header(@_);}elsif($WC::c->{'res'}->{'type'}eq 'AJAX'){&show_error_AJAX_no_header(@_);}else{&show_error_TEXT_no_header(@_);}}sub show_error_HTML_no_header(){&_print_MESSAGE('HTML','ERROR',0,@_);}sub show_error_AJAX_no_header(){&_print_MESSAGE('AJAX','ERROR',0,@_);}sub show_error_TEXT_no_header(){&_print_MESSAGE('TEXT','ERROR',0,@_);}sub show_info(){if($WC::c->{'res'}->{'type'}eq 'HTML'){&show_info_HTML(@_);}elsif($WC::c->{'res'}->{'type'}eq 'AJAX'){&show_info_AJAX(@_);}else{&show_info_TEXT(@_);}}sub show_info_HTML(){&_print_MESSAGE('HTML','INFO',1,@_);}sub show_info_AJAX(){&_print_MESSAGE('AJAX','INFO',1,@_);}sub show_info_TEXT(){&_print_MESSAGE('TEXT','INFO',1,@_);}sub show_info_no_header(){if($WC::c->{'res'}->{'type'}eq 'HTML'){&show_info_HTML_no_header(@_);}elsif($WC::c->{'res'}->{'type'}eq 'AJAX'){&show_info_AJAX_no_header(@_);}else{&show_info_TEXT_no_header(@_);}}sub show_info_HTML_no_header(){&_print_MESSAGE('HTML','INFO',0,@_);}sub show_info_AJAX_no_header(){&_print_MESSAGE('AJAX','INFO',0,@_);}sub show_info_TEXT_no_header(){&_print_MESSAGE('TEXT','INFO',0,@_);}sub show_warning(){if($WC::c->{'res'}->{'type'}eq 'HTML'){&show_warning_HTML(@_);}elsif($WC::c->{'res'}->{'type'}eq 'AJAX'){&show_warning_AJAX(@_);}else{&show_warning_TEXT(@_);}}sub show_warning_HTML(){&_print_MESSAGE('HTML','WARNING',1,@_);}sub show_warning_AJAX(){&_print_MESSAGE('AJAX','WARNING',1,@_);}sub show_warning_TEXT(){&_print_MESSAGE('TEXT','WARNING',1,@_);}sub show_warning_no_header(){if($WC::c->{'res'}->{'type'}eq 'HTML'){&show_warning_HTML_no_header(@_);}elsif($WC::c->{'res'}->{'type'}eq 'AJAX'){&show_warning_AJAX_no_header(@_);}else{&show_warning_TEXT_no_header(@_);}}sub show_warning_HTML_no_header(){&_print_MESSAGE('HTML','WARNING',0,@_);}sub show_warning_AJAX_no_header(){&_print_MESSAGE('AJAX','WARNING',0,@_);}sub show_warning_TEXT_no_header(){&_print_MESSAGE('TEXT','WARNING',0,@_);}sub _print_MESSAGE{my($in_format,$in_type,$in_show_header,$in_message,$in_info,$in_id)=@_;
$in_format='TEXT' if(!defined$in_format||$in_format eq '');
$in_type='INFO' if(!defined$in_type||$in_type eq '');
$in_show_header=1 if(!defined$in_show_header);
$in_message='' if(!defined$in_message);
$in_info='' if(!defined$in_info);
$in_id='' if(!defined$in_id);
if($in_format eq 'AJAX'){if($in_type eq 'ERROR'){&WC::AJAX::show_error($in_message,$in_info,$in_id);}elsif($in_type eq 'WARNING'){&WC::AJAX::show_warning($in_message,$in_info,$in_id);}elsif($in_type eq 'INFO'){&WC::AJAX::show_info($in_message,$in_info,$in_id);}}elsif($in_format eq 'HTML'){&print_HTTP_HEADER()if($in_show_header);
if($in_type eq 'ERROR'){&WC::HTML::show_error($in_message,$in_info,$in_id);}elsif($in_type eq 'WARNING'){&WC::HTML::show_warning($in_message,$in_info,$in_id);}elsif($in_type eq 'INFO'){&WC::HTML::show_info($in_message,$in_info,$in_id);}}else{my$text=$WC::c->{'APP_SETTINGS'}->{'name'};
&print_HTTP_HEADER()if($in_show_header);
if($in_type eq 'ERROR'){$text.=' ERROR:'}elsif($in_type eq 'WARNING'){$text.=' WARNING:'}else{$text.=' INFO:'}$text.=" $in_message\n";
$text.="$in_info\n" if($in_info ne '');
if($in_id ne ''){$text.='Solution for that problem at '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ: '.$WC::CONST->{'URLS'}->{'FAQ_ID'}.$in_id;}else{$text.='You can try to find solution for that problem at '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ: '.$WC::CONST->{'URLS'}->{'FAQ'};}$text=~s/\n/<br \/>\n/g;
print$text;}}package WC::Response::MimeTypes;
use strict;
$WC::Response::MimeTypes::ALL={''=>'application/octet-stream'};
foreach(split(/\n/, <<END
video/mpeg			mpeg mpg mpe
application/msword		doc
application/ogg			ogg
application/pdf			pdf
application/postscript		ai eps ps
application/vnd.ms-excel	xls
application/vnd.ms-powerpoint	ppt
application/x-cpio		cpio
application/x-dvi		dvi
application/x-gtar		gtar
application/x-javascript	js
application/x-latex		latex
application/x-netcdf		nc cdf
application/x-sh		sh
application/x-shockwave-flash	swf
application/x-tar		tar
application/x-tcl		tcl
application/x-tex		tex
application/x-troff-man		man
application/xhtml+xml		xhtml xht
application/xslt+xml		xslt
application/xml			xml xsl
application/xml-dtd		dtd
application/zip			zip
audio/basic			au snd
audio/midi			mid midi kar
audio/mpeg			mpga mp2 mp3
audio/x-aiff			aif aiff aifc
audio/x-mpegurl			m3u
audio/x-pn-realaudio		ram ra
application/vnd.rn-realmedia	rm
audio/x-wav			wav
image/bmp			bmp
image/cgm			cgm
image/gif			gif
image/ief			ief
image/jpeg			jpeg jpg jpe
image/png			png
image/svg+xml			svg
image/tiff			tiff tif
image/vnd.djvu			djvu djv
image/x-icon			ico
image/x-rgb			rgb
image/x-xbitmap			xbm
image/x-xpixmap			xpm
image/x-xwindowdump		xwd
model/vrml			wrl vrml
text/css			css
text/html			html htm
text/plain			asc txt
text/richtext			rtx
text/rtf			rtf
text/sgml			sgml sgm
text/vnd.wap.wml		wml
text/vnd.wap.wmlscript		wmls
video/mpeg			mpeg mpg mpe
video/quicktime			qt mov
video/vnd.mpegurl		mxu m4u
video/x-msvideo			avi
video/x-sgi-movie		movie
END
)){if($_=~/^[ \s\t]{0,}([^ \s\t]+)[ \s\t]{1,}(.+)$/){my$type=$1;
my@arr_ext=split(/ /,&NL::String::str_trim($2));
foreach(@arr_ext){$WC::Response::MimeTypes::ALL->{$_}=$type if(!defined$WC::Response::MimeTypes::ALL->{$_});}}}package WC::Response::Download;
use strict;
$WC::Response::Download::HEADERS={'end'=>"Cache-Control: public\n"."Pragma: public\n"."Expires: 0\n"};
$WC::Response::Download::TEMP={'file_name'=>''};
sub start{my($in_HASH_DATA)=@_;
my$BYTES_READ_BUFFER=1024*10;
my$is_OK=0;
if(!defined$in_HASH_DATA){&WC::Response::show_info_HTML('Incorrect method call, are you hacker?');}else{if(!defined$in_HASH_DATA->{'dir'}||!$in_HASH_DATA->{'file'}){&WC::Response::show_info_HTML('Incorrect method call, are you hacker?');}else{my$method=(defined$in_HASH_DATA->{'method'})?$in_HASH_DATA->{'method'}:'';
my$dir=&WC::Dir::check_in($in_HASH_DATA->{'dir'});
my$dir_ENC_INTERNAL=&WC::Dir::check_in($in_HASH_DATA->{'dir'});
if($dir eq ''){$dir=$WC::c->{'config'}->{'directorys'}->{'work'};}else{&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);}if(!&WC::Dir::change_dir($dir)){&WC::Response::show_info_HTML('Unable change directory to "'.&NL::String::get_right($dir_ENC_INTERNAL,60,1).'"'.(($!ne '')?': '.$!:''));}else{my$file=&WC::Dir::check_in($in_HASH_DATA->{'file'});
my$file_ENC_INTERNAL=$file;
&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$file);
my$file_ENC_INTERNAL_small=&NL::String::get_right($file,60,1);
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC_INTERNAL_small);
if(!-f$file){&WC::Response::show_info_HTML('There is no file "'.$file_ENC_INTERNAL_small.'" found'.(($!ne '')?': '.$!:''));}else{my$size=&WC::File::get_size($file);
if(!&WC::File::lock_read($file,{'timeout'=>10,'time_sleep'=>0.1})){&WC::Response::show_info_HTML('File "'.$file_ENC_INTERNAL_small.'" can\'t be locked for reading'.(($!ne '')?': '.$!:''));}else{$WC::Response::Download::TEMP->{'file_name'}=$file;
if(!open(FH_DOWNLOAD,'<'.$file)){&WC::Response::show_info_HTML('File "'.$file_ENC_INTERNAL_small.'" can\'t be opened'.(($!ne '')?': '.$!:''));}else{$is_OK=1;
my$file_ext=($file=~/\.([^\.]{0,})$/)?$1:'';
$file_ext=~s/\.([^\.]{0,})$/$1/;
my$http_content_type=(defined$WC::Response::MimeTypes::ALL->{$file_ext})?$WC::Response::MimeTypes::ALL->{$file_ext}:$WC::Response::MimeTypes::ALL->{''};
binmode FH_DOWNLOAD;
binmode STDOUT;
print"Content-Type: $http_content_type\n";
print"Content-Length: $size\n";
if($method ne 'open'){my$file_NAME=$file_ENC_INTERNAL;
$file_NAME=&WC::File::get_name($file_NAME);
&WC::Encode::encode_from_INTERNAL_to_FILE_DOWNLOAD(\$file_NAME);
print"Content-Disposition: attachment; filename=\"$file_NAME\"\n";}print$WC::Response::Download::HEADERS->{'end'};
print"\n";
while(read FH_DOWNLOAD,$_,$BYTES_READ_BUFFER){print;}close(FH_DOWNLOAD);
&WC::File::unlock($file);
$WC::Response::Download::TEMP->{'file_name'}='';}}}}}}}END{if(defined$WC::Response::Download::TEMP->{'file_name'}&&$WC::Response::Download::TEMP->{'file_name'}ne ''){&WC::File::unlock($WC::Response::Download::TEMP->{'file_name'});}}package WC::AJAX;
use strict;
$WC::AJAX::DATA={'DYNAMIC'=>{'AJAX_INITIALIZED'=>0}};
sub init{my$in_PARAMS=$WC::c->{'request'}->{'params'};
if(&NL::AJAX::init($WC::c->{'request'}->{'params'})){$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_INITIALIZED'}=1;
if(defined$WC::c->{'request'}->{'params'}->{'AJAX_REQUEST_ID'}){$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'}=$WC::c->{'request'}->{'params'}->{'AJAX_REQUEST_ID'};}return 1;}return 0;}sub show_response_NO_TEXT_ENCODE{return&show_response(defined$_[0]?$_[0]:'',defined$_[1]?$_[1]:'',defined$_[2]?$_[2]:{},defined$_[3]?$_[3]:{},1);}sub show_response{my($in_ACTION,$in_TEXT,$in_ACTION_PARAMS,$in_STASH,$in_DONT_ENCODE_TEXT)=@_;
$in_ACTION='' if(!defined$in_ACTION);
$in_TEXT='' if(!defined$in_TEXT);
$in_ACTION_PARAMS={}if(!defined$in_ACTION_PARAMS);
$in_STASH={}if(!defined$in_STASH);
if($WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_INITIALIZED'}){&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$in_TEXT)if($in_TEXT ne ''&&!defined$in_DONT_ENCODE_TEXT||!$in_DONT_ENCODE_TEXT);
&NL::Utils::hash_foreach_REF($in_ACTION_PARAMS,\&WC::Encode::encode_from_SYSTEM_to_INTERNAL);
&NL::Utils::hash_foreach_REF($in_STASH,\&WC::Encode::encode_from_SYSTEM_to_INTERNAL);
my$hash_RESULT={'text'=>$in_TEXT,'action'=>$in_ACTION,'action_params'=>$in_ACTION_PARAMS,'STASH'=>$in_STASH};
if(defined$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'}&&$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'}ne ''){$hash_RESULT->{'id'}=$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'};}if(!&NL::AJAX::show_response($hash_RESULT,'',$WC::CONST->{'HTTP_EXTRA_HEADERS'})){&WC::Response::show_error_TEXT('Unable to make AJAX response (but AJAX is initialized)','Looks like it was bad AJAX request','WC_AJAX_UNABLE_MAKE_RESPONSE_AJAX_INITIALIZED');}}else{&WC::Response::show_error_TEXT('Unable to make AJAX response (AJAX is not initialized)','Looks like it was bad AJAX request','WC_AJAX_UNABLE_MAKE_RESPONSE_AJAX_NOT_INITIALIZED');}}sub show_info{&_show_REPORT('INFO',\@_);}sub show_warning{&_show_REPORT('WARNING',\@_);}sub show_error{&_show_REPORT('ERROR',\@_);}sub _show_REPORT{my($in_TYPE,$in_PARAMS)=@_;
my$ref_ELEMENTS=[];
if(defined$in_PARAMS&&scalar@{$in_PARAMS}>0){if(ref$in_PARAMS->[0]eq 'ARRAY'){$ref_ELEMENTS=$in_PARAMS->[0];}else{my$element_type='INFORMATION';
if($in_TYPE eq 'WARNING'){$element_type='WARNING';}elsif($in_TYPE eq 'ERROR'){$element_type='ERROR';}my($in_msg,$in_info,$in_id)=@{$in_PARAMS};
$ref_ELEMENTS=[{'TYPE'=>$element_type,'id'=>(defined$in_id)?$in_id:'','message'=>(defined$in_msg)?$in_msg:'','info'=>(defined$in_info)?$in_info:''}];}}my$report={};
if(scalar@{$ref_ELEMENTS}>0){$report=&WC::HTML::Report::make_REPORT_MAIN($ref_ELEMENTS);}&show_response($in_TYPE,(defined$report->{'TEXT'})?$report->{'TEXT'}:'',{'content-type'=>'HTML'},{});}package WC::HTML;
use strict;
sub _init_pages{$WC::HTML::PAGES_DATA={'html_error'=>{'PAGE_TYPE'=>'error','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Error','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-ERROR">Error</span></a>','main_info'=>''},'html_warning'=>{'PAGE_TYPE'=>'warning','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Warning','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-WARNING">Warning</span></a>','main_info'=>''},'html_info'=>{'PAGE_TYPE'=>'info','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Informational message','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-INFO">Informational message</span></a>','main_info'=>''},'html_install'=>{'PAGE_TYPE'=>'install','PAGE_ACTION'=>'','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Installation','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">* '.$WC::c->{'APP_SETTINGS'}->{'name'}.' Installation *</a>','main_info'=>'<div class="install-ALL-CHECKED-OK">All required permissions are checked - all is OK.</div>'.'<div class="install-DETAIL">You can read detailed installation instructions <a href="http://www.web-console.org/installation/#WEB_PHASE" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instructions (with screenshots)" target="_blank">here</a>.</div>'.'<div class="install-TODO">Please enter login, password and e-mail for the '.$WC::c->{'APP_SETTINGS'}->{'name'}.' administrator:</div>','user_login'=>'','user_password'=>'','user_email'=>'','encoding_SERVER_CONSOLE'=>'','encoding_SERVER_SYSTEM'=>'','encoding_EDITOR_TEXT'=>'','ENCODE_ON'=>1,'ENCODE_ERROR'=>'','ENCODE_ENCODING'=>'','ENCODE_AREA_SHOW'=>0},'html_installed'=>{'PAGE_TYPE'=>'installed','PAGE_ACTION'=>'','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Installation','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">* '.$WC::c->{'APP_SETTINGS'}->{'name'}.' Installation *</a>','main_info'=>'<div class="installed-TITLE">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' has been successfully installed.</div>'.'<div class="installed-MAIN"><table><tr><td>'.'<div class="installed-LOGON">You can now <a href="'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'?logon_rand='.(time()).'" title="Login to '.$WC::c->{'APP_SETTINGS'}->{'name'}.'">LOGIN</a> using administrator\'s login and password.</div>'.'<div class="installed-USAGE">Most common '.$WC::c->{'APP_SETTINGS'}->{'name'}.' usage you can find here:<br />'.'&nbsp;&nbsp;&nbsp;&nbsp;<span class="installed-DASH">&mdash;</span> <a href="http://www.web-console.org/category/usage/" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' Usage" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' Usage</a><br />'.'&nbsp;&nbsp;&nbsp;&nbsp;<span class="installed-DASH">&mdash;</span> <a href="http://www.web-console.org/faq/" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ</a><br />'.'&nbsp;&nbsp;&nbsp;&nbsp;<span class="installed-DASH">&mdash;</span> <a href="http://forum.web-console.org" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM</a>'.'</div>'.'<div class="installed-SERVICES">'.'<a class="installed-SERVICES-LINK" href="http://www.web-console.org/about_us/" title="Read more information about Web Console Group" target="_blank">Web Console Group</a> also provides web application development, server<br />'.'configuration, technical support, security analysis, consulting and other services.<br />'.'To get more information about it please visit to <a href="http://services.web-console.org" title="Read more information about Web Console Group services" target="_blank">Web Console Group services</a> page.'.'</div>'.'<div class="installed-area-LOGIN">'.'<div id="_installed-LOGIN-button" class="installed-LOGIN-button">LOGIN TO WEB CONSOLE</div>'.'</div>'.'</td></tr></table></div>'.'<div class="installed-FOOTER">'.'Thank you for choosing <a href="http://www.web-console.org" target="_blank" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' project official website">'.$WC::c->{'APP_SETTINGS'}->{'name'}.'</a>!'.'</div>'.'<script type="text/JavaScript"><!--'."\n"."NL.UI.div_button_register('installed-LOGIN-button', '_installed-LOGIN-button', function() { document.location = '".$WC::c->{'APP_SETTINGS'}->{'file_name'}."?logon_rand=".(time())."'; }, {});"."\n".'//--></script>'},'html_MOD_PERL'=>{'PAGE_TYPE'=>'warning','PAGE_ACTION'=>'','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: MOD_PERL detected','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-WARNING">MOD_PERL detected</span></a>','main_info'=>''},'html_logon'=>{'PAGE_TYPE'=>'logon','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Logon','main_title'=>'<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' Logon</a>','main_info'=>'<div class="logon-TODO">Please enter login/password</div>','user_login'=>'','user_password'=>''},'html_console'=>{'PAGE_TYPE'=>'console','page_title'=>':: '.$WC::c->{'APP_SETTINGS'}->{'name'},'show_wellcome'=>1,'user_login'=>'','user_password_encrypted'=>'','dir_current'=>''}};}sub show_page{my($in_PAGE_ID,$in_STASH)=@_;
$in_PAGE_ID='' if(!defined$in_PAGE_ID);
$in_STASH={}if(!defined$in_STASH);
my$WC_PAGE='';
my$WC_HTML={};
&_init_pages()if(!defined$WC::HTML::PAGES_DATA);
$WC_HTML=$WC::HTML::PAGES_DATA->{$in_PAGE_ID}if(defined$WC::HTML::PAGES_DATA->{$in_PAGE_ID});
$WC_HTML->{'APP_file'}=$WC::c->{'APP_SETTINGS'}->{'file_name'};
if($in_PAGE_ID eq 'html_logon'){$WC_PAGE='page_all_others';}elsif($in_PAGE_ID eq 'html_console'){&WC::Dir::update_current_dir();
$WC_HTML->{'dir_current'}=&NL::String::str_escape_JSON(&WC::Dir::get_current_dir());
$WC_PAGE='page_console';
$WC_HTML->{'ADDITIONAL_JAVASCRIPT'}='';
$WC_HTML->{'flag_show_warnings'}=1;
$WC_HTML->{'flag_show_welcome'}=1;
$WC_HTML->{'IS_DEMO'}=0;
$WC_HTML->{'js_APP_SETTINGS_FILE_NAME'}=&NL::String::str_JS_value($WC::c->{'APP_SETTINGS'}->{'file_name'});
$WC_HTML->{'STYLE_CONSOLE_FONT_FAMILY'}=$WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'family'};
$WC_HTML->{'STYLE_CONSOLE_FONT_SIZE'}=$WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'size'};
$WC_HTML->{'STYLE_CONSOLE_FONT_COLOR'}=$WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'color'};
if(defined$WC::c->{'config'}&&defined$WC::c->{'config'}->{'logon'}){$WC_HTML->{'flag_show_warnings'}=0 if(defined$WC::c->{'config'}->{'logon'}->{'show_warnings'}&&!$WC::c->{'config'}->{'logon'}->{'show_warnings'});
$WC_HTML->{'flag_show_welcome'}=0 if(defined$WC::c->{'config'}->{'logon'}->{'show_welcome'}&&!$WC::c->{'config'}->{'logon'}->{'show_welcome'});
if(defined$WC::c->{'config'}->{'logon'}->{'javascript'}&&$WC::c->{'config'}->{'logon'}->{'javascript'}!~/^[\r\n\t]{0,}$/){$WC_HTML->{'ADDITIONAL_JAVASCRIPT'}.="// Additional JavaScript :: Global JavaScript\n";
$WC_HTML->{'ADDITIONAL_JAVASCRIPT'}.=$WC::c->{'config'}->{'logon'}->{'javascript'};}}if(defined$WC::c->{'user'}&&defined$WC::c->{'user'}->{'additional'}){if(defined$WC::c->{'user'}->{'additional'}->{'logon'}){$WC_HTML->{'flag_show_warnings'}=$WC::c->{'user'}->{'additional'}->{'logon'}->{'show_warnings'}if(defined$WC::c->{'user'}->{'additional'}->{'logon'}->{'show_warnings'});
$WC_HTML->{'flag_show_welcome'}=$WC::c->{'user'}->{'additional'}->{'logon'}->{'show_welcome'}if(defined$WC::c->{'user'}->{'additional'}->{'logon'}->{'show_welcome'});
if(defined$WC::c->{'user'}->{'additional'}->{'logon'}->{'javascript'}&&$WC::c->{'user'}->{'additional'}->{'logon'}->{'javascript'}!~/^[\r\n\t]{0,}$/){$WC_HTML->{'ADDITIONAL_JAVASCRIPT'}.="\n" if($WC_HTML->{'ADDITIONAL_JAVASCRIPT'}ne '');
$WC_HTML->{'ADDITIONAL_JAVASCRIPT'}.="// Additional JavaScript :: User JavaScript\n";
$WC_HTML->{'ADDITIONAL_JAVASCRIPT'}.=$WC::c->{'user'}->{'additional'}->{'logon'}->{'javascript'};}}}}elsif($in_PAGE_ID eq 'html_MOD_PERL'){$WC_PAGE='page_all_others';
my$report=&WC::HTML::Report::make_REPORT_MOD_PERL([{'TYPE'=>'WARNING','id'=>'MOD_PERL_DETECTED','message'=>$WC::c->{'APP_SETTINGS'}->{'name'}.' has detected <a class="m-bold" title="Read more information about mod_perl" target="_blank" href="http://perl.apache.org">mod_perl</a>, '.'script &quot;<b>'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'</b>&quot; should be executed by web server without <b>mod_perl</b>.','info'=>'Simple Apache configuration to run '.$WC::c->{'APP_SETTINGS'}->{'name'}.' without <b>mod_perl</b> will looks like that:'.'<div class="report-block-MOD_PERL-code"><pre>AddHandler cgi-script .cgi .pl'."\n".'&lt;Directory /var/www/web-console/&gt;'."\n".'	AllowOverride All'."\n".'	Options +FollowSymLinks +ExecCGI'."\n".'&lt;/Directory&gt;</pre></div>'}]);
$WC_HTML->{'main_info'}=$report->{'TEXT'};}elsif($in_PAGE_ID eq 'html_install'){$WC_PAGE='page_all_others';
$WC_HTML->{'ENCODE_ON'}=(&WC::Encode::IS_ENCODE_ON())?1:0;}elsif($in_PAGE_ID eq 'html_installed'){$WC_PAGE='page_all_others';}elsif($in_PAGE_ID eq 'html_error'){$WC_PAGE='page_all_others';}elsif($in_PAGE_ID eq 'html_warning'){$WC_PAGE='page_all_others';}elsif($in_PAGE_ID eq 'html_info'){$WC_PAGE='page_all_others';}else{&show_error('Incorrect call of \'WC::HTML::show_page\'','That is very strange, looks like some plugin has made incorrect call','ERROR_WC_HTML_SHOW_PAGE_INCORRECT_CALL');}if($WC_PAGE ne ''){&_print_HTML($WC_PAGE,$WC_HTML,$in_STASH);}}sub show_info{&_show_REPORT('html_info',\@_);}sub show_warning{&_show_REPORT('html_warning',\@_);}sub show_error{&_show_REPORT('html_error',\@_);}sub _show_REPORT{my($in_TYPE,$in_PARAMS)=@_;
my$ref_ELEMENTS=[];
if(defined$in_PARAMS&&scalar@{$in_PARAMS}>0){if(ref$in_PARAMS->[0]eq 'ARRAY'){$ref_ELEMENTS=$in_PARAMS->[0];}else{my$element_type='INFORMATION';
if($in_TYPE eq 'html_warning'){$element_type='WARNING';}elsif($in_TYPE eq 'html_error'){$element_type='ERROR';}my($in_msg,$in_info,$in_id)=@{$in_PARAMS};
$ref_ELEMENTS=[{'TYPE'=>$element_type,'id'=>(defined$in_id)?$in_id:'','message'=>(defined$in_msg)?$in_msg:'','info'=>(defined$in_info)?$in_info:''}];}}my$report={};
if(scalar@{$ref_ELEMENTS}>0){$report=&WC::HTML::Report::make_REPORT_MAIN($ref_ELEMENTS);}&show_page($in_TYPE,{'main_info'=>(defined$report->{'TEXT'})?$report->{'TEXT'}:''});}sub get_message_INCORRECT_PARAMETERS{my($in_message)=@_;
if(!defined$in_message){$in_message=['__UNKNOWN_MESSAGE__'];}else{if(!ref$in_message){$in_message=[$in_message];}}my$result='';
foreach(@{$in_message}){$result.='&nbsp;&nbsp;-&nbsp;'.(&NL::String::str_HTML_full($_));}return&get_message('INCORRECT INPUT PARAMETERS',$result);}sub get_message_GOOD{my($in_message)=@_;
if(!defined$in_message){$in_message='__UNKNOWN_MESSAGE__';}return '<div class="t-lime">&nbsp;&nbsp;&nbsp;<span class="t-blue">***</span>&nbsp;'.(&NL::String::str_HTML_full($in_message)).'</div>';}sub get_message{my($in_title,$in_message,$in_settings)=@_;
if(!defined$in_title){$in_title='__NO_TITLE__';}if(!defined$in_message){$in_message='__UNKNOWN_MESSAGE__';}if(!defined$in_settings){$in_settings={};}if(defined$in_settings->{'AUTO_BR'}&&$in_settings->{'AUTO_BR'}){&NL::String::str_trim(\$in_message);
$in_message=~s/^/  - /;
$in_message=~s/\n/\n    /g;}if(!defined$in_settings->{'ENCODE_TO_HTML'}||$in_settings->{'ENCODE_TO_HTML'}){$in_message=&NL::String::str_HTML_full($in_message);}return '<div class="t-lime">'.$in_title.':</div><div class="t-blue">'.$in_message.'</div>';}sub get_short_value{my($in_message,$in_SETTINGS)=@_;
if(!defined$in_message){$in_message='__NO_DATA__';}$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'MAX_LENGTH'}=40 if(!defined$in_SETTINGS->{'MAX_LENGTH'});
my$str='<span class="s-link" style="cursor: help; font-style: normal" title="'.(&NL::String::str_HTML_value($in_message)).'">'.(&NL::String::str_HTML_value(&NL::String::get_right($in_message,$in_SETTINGS->{'MAX_LENGTH'},1))).'</span>';
if(!defined$in_SETTINGS->{'NO_QUOT'}&&!$in_SETTINGS->{'NO_QUOT'}){$str='&quot;'.$str.'&quot;';}return$str;}sub _get_CSS{my($in_ID)=@_;
if($in_ID eq 'page_all_others'){return '';}elsif($in_ID eq 'page_console'){return '';}return '';}sub _print_HTML{my($in_ID,$in_ref_WC_HTML,$in_ref_STASH)=@_;
my%WC_HTML=%{$in_ref_WC_HTML};
foreach(keys%WC_HTML){$WC_HTML{$_}=$in_ref_STASH->{$_}if(defined$in_ref_STASH->{$_});}if($in_ID eq 'page_all_others'){$WC_HTML{'__CSS__'}=&_get_CSS($in_ID);
print <<_HTML_CODE_EOF;
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
	<!-- WEB CONSOLE HTML :: INFORMATIONAL PAGE -->
	<!-- (C) 2008 Nickolay Kovalev, http://resume.nickola.ru -->
	<!-- Web Console URL: http://www.web-console.org -->
	<!-- Last version of Web Console can be downloaded from: http://www.web-console.org/download/ -->
	<!-- Web Console Group services: http://services.web-console.org -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="author" content="Nickolay Kovalev | http://resume.nickola.ru" />
	<meta name="robots" content="NONE" />
	<title>$WC_HTML{'page_title'}</title>
<style type="text/css" media="all">
*{margin:0;padding:0;background-color:#000;color:#bbb;font-weight:normal;font-size:12px;font-family:verdana,helvetica,arial,sans-serif;}a,a:visited,a:active,a:hover{background-color:#000;color:#bbb;text-decoration:underline;}html,body{margin:0;padding:0;height:100%;}div{margin:0;padding:0;}form{margin:0;padding:0;}input{font-family:verdana,helvetica,arial,sans-serif;color:#bbb;font-size:12px;border:1px solid #bbb;}#layout{width:100%;height:100%;border:0;border-collapse:collapse;}#layout-td{padding:6px;margin:0;vertical-align:middle;text-align:center;font-weight:bold;}#block-no-JS{border:1px solid #e51b16;line-height:150%;color:#1196cb;text-align:center;margin:16px auto;padding:10px;width:430px;}#block-no-JS-FAQ{color:#a995cd;padding:0;margin:0;text-align:right;font-weight:bold;}#block-no-JS-FAQ a,#block-no-JS-FAQ a:visited,#block-no-JS-FAQ a:active,#block-no-JS-FAQ a:hover{color:#a995cd;font-weight:bold;}#block-CONTENT{display:none;}#block-main{padding:0;margin:auto;width:auto;border:0;border-collapse:collapse;text-align:center;}#block-main-title,#block-main-title .t-MARK-ERROR,#block-main-title .t-MARK-WARNING,#block-main-title .t-MARK-INFO,#block-main-title a,#block-main-title a:visited,#block-main-title a:active,#block-main-title a:hover{text-align:center;padding:0 0 3px 0;font-weight:bold;font-size:28px;color:#009964;}#block-main-title .t-MARK-ERROR{color:#e51b16;}#block-main-title .t-MARK-WARNING{color:#1196cb;}#block-main-title .t-MARK-INFO{color:#1196cb;}#block-main-title a,#block-main-title a:visited,#block-main-title a:active,#block-main-title a:hover{text-decoration:none;}#block-main-info{padding:0 0 6px 0;text-align:center;font-weight:bold;color:#219860;}#block-FORM{text-align:center;width:auto;margin:auto;border:0;border-collapse:collapse;}#block-FORM .form-label{white-space:nowrap;padding:1px 3px;text-align:left;font-weight:bold;vertical-align:middle;color:#528c6a;}#block-FORM .form-input{padding:2px 3px;text-align:left;vertical-align:middle;}#block-FORM .form-input input{padding:1px 3px;font-weight:normal;vertical-align:middle;width:140px;}#block-FORM .form-submit-fake{padding:0;text-align:right;vertical-align:bottom;}#block-FORM .form-submit-fake input{width:1px;height:1px;font-size:1px;padding:0;margin:0;border:0 solid #000;outline:none;}#block-FORM .form-submit{padding:6px 3px;text-align:right;vertical-align:middle;}#block-FORM .form-encoding{padding:0 3px;text-align:right;vertical-align:middle;}#block-switcher{text-align:right;border-collapse:collapse;margin:3px 0 3px auto;}#block-switcher td.left{text-align:right;padding:0;width:auto;vertical-align:middle;}#block-switcher td.left input{margin:0;padding:0;border:0;}#block-switcher td.right{text-align:left;padding:0 0 0 6px;width:auto;white-space:nowrap;vertical-align:middle;}#block-switcher td.right label{color:#23d500;font-weight:bold;vertical-align:middle;}#block-switcher-ENCODING{text-align:right;border-collapse:collapse;margin:3px 0 0 auto;}#block-switcher-ENCODING .form-encoding-label{cursor:help;white-space:nowrap;padding:2px 0;text-align:right;font-weight:bold;vertical-align:middle;color:#528c6a;}#block-switcher-ENCODING .form-encoding-input{padding:1px 0;text-align:right;vertical-align:middle;}#block-switcher-ENCODING .form-encoding-input input{padding:1px 3px;font-weight:normal;vertical-align:middle;width:140px;}#_use_ENCODINGS_switcher{background-color:#000;width:auto;height:auto;padding:0;margin:0 4px 0 0;}#block-footer{margin:16px auto auto auto;text-align:center;}#block-footer a,#block-footer a:visited,#block-footer a:active,#block-footer a:hover{text-decoration:none;font-weight:bold;font-size:17px;color:#b48c00;}.div-switcher-pressed{display:block;}.div-switcher-unpressed{display:none;}.div-button-unpressed,.div-button-pressed{width:90px;margin:0 0 0 auto;padding:2px 6px 2px 6px;text-align:center;vertical-align:middle;border:1px solid #bbb;background-color:#333;cursor:default;}.div-button-pressed{padding:3px 5px 1px 7px;}.t-encoding-read-link,.t-encoding-read-link a,.t-encoding-read-link a:visited,.t-encoding-read-link a:active,.t-encoding-read-link a:hover,.t-encoding,.t-encoding-example{text-align:right;margin:0 0 0 auto;padding:0;border:0;font-weight:normal;font-size:11px;color:#b48c00;}.t-encoding{color:#1196cb;}.t-encoding-example{color:#219860;}.t-encoding-marked,.t-encoding-marked a,.t-encoding-marked a:visited,.t-encoding-marked a:active,.t-encoding-marked a:hover{color:#23d500;font-weight:normal;font-size:11px;}.t-encoding-marked a:hover{color:#090;}.t-encoding-marked a,.t-encoding-marked a:visited,.t-encoding-marked a:active,.t-encoding-marked a:hover{text-decoration:none;}#block-encoding-WARNING{text-align:center;width:auto;margin:auto;border:0;border-collapse:collapse;}#block-encoding-WARNING td{text-align:left;}#block-encoding-WARNING .encoding-WARNING-title{padding:12px 0 4px 0;text-align:left;color:#ca412d;font-weight:bold;}#block-encoding-WARNING .encoding-WARNING-main-info{padding:6px 0 3px 0;text-align:left;color:#ca412d;font-weight:bold;}#block-encoding-WARNING .encoding-WARNING-main-info-DIV{padding:0 0 3px 0;text-align:left;color:#ca412d;font-weight:normal;height:100px;width:700px;overflow:auto;}#block-encoding-WARNING .encoding-WARNING-main{text-align:left;color:#ca412d;font-weight:normal;}#block-encoding-WARNING .encoding-WARNING-main a,#block-encoding-WARNING .encoding-WARNING-main a:visited,#block-encoding-WARNING .encoding-WARNING-main a:active,#block-encoding-WARNING .encoding-WARNING-main a:hover{color:#b48c00;}#block-ENCODINGS_TITLE{padding:6px 0 0 0;margin:0;font-size:11px;color:#1196cb;}#block-ENCODINGS_LIST{text-align:right;font-weight:normal;font-size:11px;color:#23d500;height:51px;width:250px;margin:3px 0 6px auto;padding:0 5px 3px 0;overflow:auto;}#block-ENCODINGS_LIST a,#block-ENCODINGS_LIST a:active,#block-ENCODINGS_LIST a:visited,#block-ENCODINGS_LIST a:hover{font-size:11px;color:#23d500;text-decoration:none;}#block-ENCODINGS_LIST a:hover{color:#090;}.report-LAYOUT{padding:0;margin:0 auto;width:auto;border:0;border-collapse:collapse;text-align:center;}.report-LAYOUT td{text-align:left;}.report-SPLITTER{padding:0 0 8px 0;margin:8px 0 0 0;border-top:1px dashed #48736c;font-size:1px;}.report-title-ERROR,.report-title-WARNING,.report-title-INFORMATION{padding:0;margin:3px 6px 8px 0;font-size:14px;font-weight:bold;text-align:left;color:#1196cb;white-space:nowrap;}.report-MAIN{padding:8px 0 8px 0;margin:0;text-align:left;border-top:2px solid #48736c;border-bottom:2px solid #48736c;width:520px;line-height:120%;color:#aeac0d;}.report-MAIN a.m-bold,.report-MAIN a.m-bold:visited,.report-MAIN a.m-bold:active,.report-MAIN a.m-bold:hover{color:#aeac0d;font-weight:bold;text-decoration:underline;}.report-MAIN b{color:#aeac0d;font-weight:bold;}.report-FOOTER,.report-FOOTER b{padding:0;margin:6px 0 6px 0;white-space:nowrap;text-align:center;color:#00bc58;}.report-FOOTER b{font-weight:bold;}.report-FOOTER a,.report-FOOTER a:visited,.report-FOOTER a:active,.report-FOOTER a:hover{color:#00bc58;}.report-t-ERROR{color:#e51b16;font-weight:bold;}.report-t-WARNING{color:#00ab81;font-weight:bold;}.report-t-INFORMATION{color:#00ab81;font-weight:bold;}.report-b-INFO{padding:4px 0 0 0;margin:0;color:#b66712;}.report-b-INFO b{color:#b66712;font-weight:bold;}.report-b-FAQ{padding:0;margin:1px 0 0 0;white-space:nowrap;text-align:right;font-size:11px;color:#a995cd;}.report-b-FAQ a,.report-b-FAQ a:visited,.report-b-FAQ a:active,.report-b-FAQ a:hover{font-size:11px;color:#a995cd;}.report-block-MOD_PERL-code{margin:0;padding:3px 8px 0 22px;}.report-block-MOD_PERL-code pre{font-family:Courier New,Courier,Fixed;font-size:13px;color:#960;padding:0;margin:0;}.report-variable-name,.report-variable-name a,.report-variable-name a:visited,.report-variable-name a:active,.report-variable-name a:hover{color:#b66712;font-weight:bold;}.report-variable-name a,.report-variable-name a:visited,.report-variable-name a:active,.report-variable-name a:hover{text-decoration:none;}.report-dash{color:#aeac0d;font-weight:bold;}.logon-TODO{color:#1196cb;margin:auto;text-align:center;width:auto;font-weight:bold;}.logon-INCORRECT{font-size:13px;padding:0 0 2px 0;margin:0 auto 1px auto;color:#e25120;text-align:center;width:auto;font-weight:bold;}.logon-DEMO{font-size:13px;padding:4px 0 0 0;margin:0 auto 1px auto;color:#090;text-align:center;width:auto;font-weight:bold;}.install-ALL-CHECKED-OK{white-space:nowrap;font-size:14px;padding:0 0 3px 0;color:#1196cb;margin:auto;text-align:center;width:auto;font-weight:bold;}.install-DETAIL,.install-DETAIL a,.install-DETAIL a:visited,.install-DETAIL a:active,.install-DETAIL a:hover{white-space:nowrap;padding:0 0 3px 0;color:#b66712;margin:auto;text-align:center;width:auto;font-weight:bold;}.install-TODO,.install-TODO a,.install-TODO a:visited,.install-TODO a:active,.install-TODO a:hover{color:#b48c00;margin:auto;text-align:center;width:auto;font-weight:bold;}.installed-TITLE{white-space:nowrap;font-size:14px;padding:0 0 3px 0;color:#1196cb;margin:auto;text-align:center;width:auto;font-weight:bold;}.installed-MAIN{padding:8px 12px;margin:6px auto 0 auto;text-align:center;border-top:2px solid #48736c;border-bottom:2px solid #48736c;width:auto;line-height:120%;color:#aeac0d;}.installed-MAIN table{margin:auto;width:auto;border:0;border-collapse:collapse;}.installed-MAIN table td{padding:0;text-align:left;}.installed-LOGON,.installed-LOGON a,.installed-LOGON a:visited,.installed-LOGON a:active,.installed-LOGON a:hover{color:#23d500;font-weight:bold;}.installed-USAGE{padding:0;margin:6px 0 6px 0;color:#b66712;font-weight:bold;line-height:130%;}.installed-USAGE a,.installed-USAGE a:visited,.installed-USAGE a:active,.installed-USAGE a:hover,.installed-USAGE a:hover{color:#b66712;font-weight:bold;line-height:135%;}.installed-SERVICES,.installed-SERVICES a,.installed-SERVICES a:visited,.installed-SERVICES a:active,.installed-SERVICES a:hover{padding:0;margin:0;color:#c90;}a.installed-SERVICES-LINK,a.installed-SERVICES-LINK:visited,a.installed-SERVICES-LINK:active,a.installed-SERVICES-LINK:hover{color:#c90;font-weight:bold;text-decoration:none;}.installed-FOOTER{padding:0;margin:6px 0 6px 0;white-space:nowrap;text-align:center;color:#00bc58;}.installed-FOOTER a,.installed-FOOTER a:visited,.installed-FOOTER a:active,.installed-FOOTER a:hover{color:#00bc58;text-decoration:none;}.installed-DASH{color:#b66712;font-weight:bold;}.installed-area-LOGIN{padding:16px 0 10px 0;margin:auto;text-align:center;}.installed-LOGIN-button{cursor:default;margin:auto;padding:2px 8px;text-align:center;background-color:#333;border:1px solid #bbb;width:220px;}.installed-LOGIN-button-pressed{padding:3px 7px 1px 9px;}
</style>
<!--[if IE]><style type="text/css">#block-FORM .form-input { padding: 1px 3px; }</style><![endif]-->
<script type="text/javascript" language="JavaScript"><!--
xLibrary={version:"4.17",license:"GNU LGPL",url:"http://cross-browser.com/"};function xAddClass(B,C){if((B=xGetElementById(B))!=null){var A="";if(B.className.length&&B.className.charAt(B.className.length-1)!=" "){A=" "}if(!xHasClass(B,C)){B.className+=A+C;return true}}return false}function xAddEventListener(D,C,B,A){if(!(D=xGetElementById(D))){return }C=C.toLowerCase();if(D.addEventListener){D.addEventListener(C,B,A||false)}else{if(D.attachEvent){D.attachEvent("on"+C,B)}else{var E=D["on"+C];D["on"+C]=typeof E=="function"?function(F){E(F);B(F)}:B}}}function xClientHeight(){var B=0,C=document,A=window;if((!C.compatMode||C.compatMode=="CSS1Compat")&&!A.opera&&C.documentElement&&C.documentElement.clientHeight){B=C.documentElement.clientHeight}else{if(C.body&&C.body.clientHeight){B=C.body.clientHeight}else{if(xDef(A.innerWidth,A.innerHeight,C.width)){B=A.innerHeight;if(C.width>A.innerWidth){B-=16}}}}return B}function xClientWidth(){var B=0,C=document,A=window;if((!C.compatMode||C.compatMode=="CSS1Compat")&&!A.opera&&C.documentElement&&C.documentElement.clientWidth){B=C.documentElement.clientWidth}else{if(C.body&&C.body.clientWidth){B=C.body.clientWidth}else{if(xDef(A.innerWidth,A.innerHeight,C.height)){B=A.innerWidth;if(C.height>A.innerHeight){B-=16}}}}return B}function xDef(){for(var A=0;A<arguments.length;++A){if(typeof (arguments[A])=="undefined"){return false}}return true}function xGetCookie(B){var D=null,C=B+"=";if(document.cookie.length>0){var E=document.cookie.indexOf(C);if(E!=-1){E+=C.length;var A=document.cookie.indexOf(";",E);if(A==-1){A=document.cookie.length}D=unescape(document.cookie.substring(E,A))}}return D}function xGetElementById(A){if(typeof (A)=="string"){if(document.getElementById){A=document.getElementById(A)}else{if(document.all){A=document.all[A]}else{A=null}}}return A}function xHasClass(B,C){B=xGetElementById(B);if(!B||B.className==""){return false}var A=new RegExp("(^|\\\\s)"+C+"(\\\\s|\$)");return A.test(B.className)}function xRemoveClass(A,B){if(!(A=xGetElementById(A))){return false}A.className=A.className.replace(new RegExp("(^|\\\\s)"+B+"(\\\\s|\$)","g"),function(E,D,C){return(D==" "&&C==" ")?" ":""});return true}function xSetCookie(B,C,A,D){document.cookie=B+"="+escape(C)+((!A)?"":("; expires="+A.toGMTString()))+"; path="+((!D)?"/":D)}if(typeof NL=="undefined"){var NL={}}NL.namespace=function(){var A=arguments,E=null,C,B,D;for(C=0;C<A.length;C=C+1){E=NL;D=A[C].split(".");for(B=(D[0]=="NL")?1:0;B<D.length;B=B+1){E[D[B]]=E[D[B]]||{};E=E[D[B]]}}return E};NL.fe=NL.foreach=function(C,B){for(var A in C){B(A,C[A])}};NL.REDISTR_CALL=function(D,B,C){var A=D(B,C);if(A&&A[0]){return A[1]}else{alert("NL: Error, unable to call function '"+str_func+"' from REDISTR")}return 0};if(typeof NL=="undefined"){alert("NL.Browser: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Browser.Detect")}NL.Browser.Detect.isIE7=NL.Browser.Detect.isIE=NL.Browser.Detect.isFF=NL.Browser.Detect.isFF3=NL.Browser.Detect.isOPERA=NL.Browser.Detect.isSAFARI=NL.Browser.Detect.isSAFARI_MOB=false;NL.Browser.Detect.UA=function(){return(navigator.userAgent)?navigator.userAgent.toLowerCase():""}();NL.Browser.Detect._init=function(){var A=(navigator.vendor)?navigator.vendor.toLowerCase():"";if(window.opera){NL.Browser.Detect.isOPERA=true}else{if(A.indexOf("apple")!=-1){NL.Browser.Detect.isSAFARI=true;if(NL.Browser.Detect.UA.match(/iphone.*mobile.*safari/)){NL.Browser.Detect.isSAFARI_MOB=true}}else{if(A!="kde"&&document.all&&NL.Browser.Detect.UA.indexOf("msie")!=-1){NL.Browser.Detect.isIE=true;if(window.XMLHttpRequest){NL.Browser.Detect.isIE7=true}}else{if(NL.Browser.Detect.UA.indexOf("firefox")!=-1||NL.Browser.Detect.UA.indexOf("iceweasel")!=-1){NL.Browser.Detect.isFF=true;if(NL.Browser.Detect.UA.match(/(firefox|iceweasel)\\/3/)){NL.Browser.Detect.isFF3=true}}}}}}();if(typeof NL=="undefined"){alert("NL.Crypt: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Crypt","Crypt.REDISTR")}NL.Crypt.base64_encode=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.Base64,"Base64.encode",arguments)};NL.Crypt.base64_decode=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.Base64,"Base64.decode",arguments)};NL.Crypt.sha1_vm_test=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1,"sha1_vm_test",arguments)};NL.Crypt.sha1=NL.Crypt.sha1_hex=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1,"hex_sha1",arguments)};NL.Crypt.sha1_b64=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1,"b64_sha1",arguments)};NL.Crypt.get_random_text=function(){var B=(navigator.userAgent)?navigator.userAgent:"";B+=("mr1:"+Math.random()||0)+("mr2:"+Math.random()||0)+("mr3:"+Math.random()||0);B+="sw:"+screen.width||0;B+="sh:"+screen.height||0;B+="cw:"+NL.REDISTR_call(NL.Crypt.REDISTR.X,"xClientHeight",arguments)||0;B+="ch:"+NL.REDISTR_call(NL.Crypt.REDISTR.X,"xClientWidth",arguments)||0;var A=new Date();B+="t_ms:"+A.getTime()||0;B+="tz_ms:"+A.getTimezoneOffset()||0;return B};NL.Crypt.get_random_sha1=NL.Crypt.get_random_sha1_hex=function(){return NL.Crypt.sha1_hex(NL.Crypt.get_random_text())};NL.Crypt.REDISTR.X=function(){function xDef(){for(var i=0;i<arguments.length;++i){if(typeof (arguments[i])=="undefined"){return false}}return true}function xClientHeight(){var v=0,d=document,w=window;if((!d.compatMode||d.compatMode=="CSS1Compat")&&!w.opera&&d.documentElement&&d.documentElement.clientHeight){v=d.documentElement.clientHeight}else{if(d.body&&d.body.clientHeight){v=d.body.clientHeight}else{if(xDef(w.innerWidth,w.innerHeight,d.width)){v=w.innerHeight;if(d.width>w.innerWidth){v-=16}}}}return v}function xClientWidth(){var v=0,d=document,w=window;if((!d.compatMode||d.compatMode=="CSS1Compat")&&!w.opera&&d.documentElement&&d.documentElement.clientWidth){v=d.documentElement.clientWidth}else{if(d.body&&d.body.clientWidth){v=d.body.clientWidth}else{if(xDef(w.innerWidth,w.innerHeight,d.height)){v=w.innerWidth;if(d.height>w.innerHeight){v-=16}}}}return v}if(arguments.length==2&&arguments[0]!=""&&arguments[1]){var NL_TMP_FUNC=null;try{eval("NL_TMP_FUNC="+arguments[0]+";")}catch(e){NL_TMP_FUNC=null}if(NL_TMP_FUNC){return[1,NL_TMP_FUNC.apply(this,arguments[1])]}}return[0,null]};NL.Crypt.REDISTR.SHA1=function(){var hexcase=0;var b64pad="";function hex_sha1(s){return rstr2hex(rstr_sha1(str2rstr_utf8(s)))}function b64_sha1(s){return rstr2b64(rstr_sha1(str2rstr_utf8(s)))}function any_sha1(s,e){return rstr2any(rstr_sha1(str2rstr_utf8(s)),e)}function hex_hmac_sha1(k,d){return rstr2hex(rstr_hmac_sha1(str2rstr_utf8(k),str2rstr_utf8(d)))}function b64_hmac_sha1(k,d){return rstr2b64(rstr_hmac_sha1(str2rstr_utf8(k),str2rstr_utf8(d)))}function any_hmac_sha1(k,d,e){return rstr2any(rstr_hmac_sha1(str2rstr_utf8(k),str2rstr_utf8(d)),e)}function sha1_vm_test(){return hex_sha1("abc")=="a9993e364706816aba3e25717850c26c9cd0d89d"}function rstr_sha1(s){return binb2rstr(binb_sha1(rstr2binb(s),s.length*8))}function rstr_hmac_sha1(key,data){var bkey=rstr2binb(key);if(bkey.length>16){bkey=binb_sha1(bkey,key.length*8)}var ipad=Array(16),opad=Array(16);for(var i=0;i<16;i++){ipad[i]=bkey[i]^909522486;opad[i]=bkey[i]^1549556828}var hash=binb_sha1(ipad.concat(rstr2binb(data)),512+data.length*8);return binb2rstr(binb_sha1(opad.concat(hash),512+160))}function rstr2hex(input){var hex_tab=hexcase?"0123456789ABCDEF":"0123456789abcdef";var output="";var x;for(var i=0;i<input.length;i++){x=input.charCodeAt(i);output+=hex_tab.charAt((x>>>4)&15)+hex_tab.charAt(x&15)}return output}function rstr2b64(input){var tab="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";var output="";var len=input.length;for(var i=0;i<len;i+=3){var triplet=(input.charCodeAt(i)<<16)|(i+1<len?input.charCodeAt(i+1)<<8:0)|(i+2<len?input.charCodeAt(i+2):0);for(var j=0;j<4;j++){if(i*8+j*6>input.length*8){output+=b64pad}else{output+=tab.charAt((triplet>>>6*(3-j))&63)}}}return output}function rstr2any(input,encoding){var divisor=encoding.length;var remainders=Array();var i,q,x,quotient;var dividend=Array(Math.ceil(input.length/2));for(i=0;i<dividend.length;i++){dividend[i]=(input.charCodeAt(i*2)<<8)|input.charCodeAt(i*2+1)}while(dividend.length>0){quotient=Array();x=0;for(i=0;i<dividend.length;i++){x=(x<<16)+dividend[i];q=Math.floor(x/divisor);x-=q*divisor;if(quotient.length>0||q>0){quotient[quotient.length]=q}}remainders[remainders.length]=x;dividend=quotient}var output="";for(i=remainders.length-1;i>=0;i--){output+=encoding.charAt(remainders[i])}var full_length=Math.ceil(input.length*8/(Math.log(encoding.length)/Math.log(2)));for(i=output.length;i<full_length;i++){output=encoding[0]+output}return output}function str2rstr_utf8(input){var output="";var i=-1;var x,y;while(++i<input.length){x=input.charCodeAt(i);y=i+1<input.length?input.charCodeAt(i+1):0;if(55296<=x&&x<=56319&&56320<=y&&y<=57343){x=65536+((x&1023)<<10)+(y&1023);i++}if(x<=127){output+=String.fromCharCode(x)}else{if(x<=2047){output+=String.fromCharCode(192|((x>>>6)&31),128|(x&63))}else{if(x<=65535){output+=String.fromCharCode(224|((x>>>12)&15),128|((x>>>6)&63),128|(x&63))}else{if(x<=2097151){output+=String.fromCharCode(240|((x>>>18)&7),128|((x>>>12)&63),128|((x>>>6)&63),128|(x&63))}}}}}return output}function str2rstr_utf16le(input){var output="";for(var i=0;i<input.length;i++){output+=String.fromCharCode(input.charCodeAt(i)&255,(input.charCodeAt(i)>>>8)&255)}return output}function str2rstr_utf16be(input){var output="";for(var i=0;i<input.length;i++){output+=String.fromCharCode((input.charCodeAt(i)>>>8)&255,input.charCodeAt(i)&255)}return output}function rstr2binb(input){var output=Array(input.length>>2);for(var i=0;i<output.length;i++){output[i]=0}for(var i=0;i<input.length*8;i+=8){output[i>>5]|=(input.charCodeAt(i/8)&255)<<(24-i%32)}return output}function binb2rstr(input){var output="";for(var i=0;i<input.length*32;i+=8){output+=String.fromCharCode((input[i>>5]>>>(24-i%32))&255)}return output}function binb_sha1(x,len){x[len>>5]|=128<<(24-len%32);x[((len+64>>9)<<4)+15]=len;var w=Array(80);var a=1732584193;var b=-271733879;var c=-1732584194;var d=271733878;var e=-1009589776;for(var i=0;i<x.length;i+=16){var olda=a;var oldb=b;var oldc=c;var oldd=d;var olde=e;for(var j=0;j<80;j++){if(j<16){w[j]=x[i+j]}else{w[j]=bit_rol(w[j-3]^w[j-8]^w[j-14]^w[j-16],1)}var t=safe_add(safe_add(bit_rol(a,5),sha1_ft(j,b,c,d)),safe_add(safe_add(e,w[j]),sha1_kt(j)));e=d;d=c;c=bit_rol(b,30);b=a;a=t}a=safe_add(a,olda);b=safe_add(b,oldb);c=safe_add(c,oldc);d=safe_add(d,oldd);e=safe_add(e,olde)}return Array(a,b,c,d,e)}function sha1_ft(t,b,c,d){if(t<20){return(b&c)|((~b)&d)}if(t<40){return b^c^d}if(t<60){return(b&c)|(b&d)|(c&d)}return b^c^d}function sha1_kt(t){return(t<20)?1518500249:(t<40)?1859775393:(t<60)?-1894007588:-899497514}function safe_add(x,y){var lsw=(x&65535)+(y&65535);var msw=(x>>16)+(y>>16)+(lsw>>16);return(msw<<16)|(lsw&65535)}function bit_rol(num,cnt){return(num<<cnt)|(num>>>(32-cnt))}if(arguments.length==2&&arguments[0]!=""&&arguments[1]){var NL_TMP_FUNC=null;try{eval("NL_TMP_FUNC="+arguments[0]+";")}catch(e){NL_TMP_FUNC=null}if(NL_TMP_FUNC){return[1,NL_TMP_FUNC.apply(this,arguments[1])]}}return[0,null]};NL.Crypt.REDISTR.Base64=function(){var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(input){var output="";var chr1,chr2,chr3,enc1,enc2,enc3,enc4;var i=0;input=Base64._utf8_encode(input);while(i<input.length){chr1=input.charCodeAt(i++);chr2=input.charCodeAt(i++);chr3=input.charCodeAt(i++);enc1=chr1>>2;enc2=((chr1&3)<<4)|(chr2>>4);enc3=((chr2&15)<<2)|(chr3>>6);enc4=chr3&63;if(isNaN(chr2)){enc3=enc4=64}else{if(isNaN(chr3)){enc4=64}}output=output+Base64._keyStr.charAt(enc1)+Base64._keyStr.charAt(enc2)+Base64._keyStr.charAt(enc3)+Base64._keyStr.charAt(enc4)}return output},decode:function(input){var output="";var chr1,chr2,chr3;var enc1,enc2,enc3,enc4;var i=0;input=input.replace(/[^A-Za-z0-9\\+\\/\\=]/g,"");while(i<input.length){enc1=Base64._keyStr.indexOf(input.charAt(i++));enc2=Base64._keyStr.indexOf(input.charAt(i++));enc3=Base64._keyStr.indexOf(input.charAt(i++));enc4=Base64._keyStr.indexOf(input.charAt(i++));chr1=(enc1<<2)|(enc2>>4);chr2=((enc2&15)<<4)|(enc3>>2);chr3=((enc3&3)<<6)|enc4;output=output+String.fromCharCode(chr1);if(enc3!=64){output=output+String.fromCharCode(chr2)}if(enc4!=64){output=output+String.fromCharCode(chr3)}}output=Base64._utf8_decode(output);return output},_utf8_encode:function(string){string=string.replace(/\\r\\n/g,"\\n");var utftext="";for(var n=0;n<string.length;n++){var c=string.charCodeAt(n);if(c<128){utftext+=String.fromCharCode(c)}else{if((c>127)&&(c<2048)){utftext+=String.fromCharCode((c>>6)|192);utftext+=String.fromCharCode((c&63)|128)}else{utftext+=String.fromCharCode((c>>12)|224);utftext+=String.fromCharCode(((c>>6)&63)|128);utftext+=String.fromCharCode((c&63)|128)}}}return utftext},_utf8_decode:function(utftext){var string="";var i=0;var c=c1=c2=0;while(i<utftext.length){c=utftext.charCodeAt(i);if(c<128){string+=String.fromCharCode(c);i++}else{if((c>191)&&(c<224)){c2=utftext.charCodeAt(i+1);string+=String.fromCharCode(((c&31)<<6)|(c2&63));i+=2}else{c2=utftext.charCodeAt(i+1);c3=utftext.charCodeAt(i+2);string+=String.fromCharCode(((c&15)<<12)|((c2&63)<<6)|(c3&63));i+=3}}}return string}};if(arguments.length==2&&arguments[0]!=""&&arguments[1]){var NL_TMP_FUNC=null;try{eval("NL_TMP_FUNC="+arguments[0]+";")}catch(e){NL_TMP_FUNC=null}if(NL_TMP_FUNC){return[1,NL_TMP_FUNC.apply(this,arguments[1])]}}return[0,null]};if(typeof NL=="undefined"){alert("NL.UI: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("UI")}NL.UI.object_remove=function(A){if(A){var B=xGetElementById(A);if(B&&B.parentNode){B.parentNode.removeChild(B)}}};NL.UI.object_make_unselectable=function(A){if(A){var B=xGetElementById(A);if(B){if(NL.Browser.Detect.isFF){if(B.style){B.style.MozUserSelect="none"}}else{if(NL.Browser.Detect.isSAFARI){if(B.style){B.style.KhtmlUserSelect="none"}}else{if(NL.Browser.Detect.isIE||NL.Browser.Detect.isOPERA){A.unselectable="on"}}}}}};NL.UI.object_event_SCROLL=function(B,C){if(B&&C){var A=xGetElementById(B);if(A){if(NL.Browser.Detect.isIE){A.attachEvent("onmousewheel",C)}else{if(NL.Browser.Detect.isFF){A.addEventListener("DOMMouseScroll",C,false)}else{A.onmousewheel=C}}}}};NL.UI.object_event_SCROLL_get_delta=function(A,C){var B=0;if(!A){A=window.event}if(A.wheelDelta){B=A.wheelDelta/120;if(!C){A.returnValue=false}}else{if(A.detail){B=-A.detail/3;if(!C){A.preventDefault()}}}return B};NL.UI.switcher_register=function(A,C,E){var B=xGetElementById(C);if(B){if(E){B.checked=1}xAddEventListener(C,"click",function(){NL.UI.switcher_pressed(A,C);return true},false);var D=xGetElementById(C+"-LABEL");if(D){NL.UI.object_make_unselectable(D)}NL.UI.switcher_pressed(A,C)}};NL.UI.switcher_pressed=function(B,E){var D=B+"-pressed";var A=B+"-unpressed";var C=xGetElementById(E);if(C){var F=xGetElementById(E+"-AREA");if(F){if(C.checked){if(xHasClass(F,A)){xRemoveClass(F,A);xAddClass(F,D)}}else{if(xHasClass(F,D)){xRemoveClass(F,D);xAddClass(F,A)}}C.blur()}}};NL.UI.div_button_register=function(C,E,B,A){var D=xGetElementById(E);if(D){NL.UI.object_make_unselectable(D);xAddEventListener(E,"mousedown",function(){NL.UI.div_button_pressed(C,E,1,B,A)},false);xAddEventListener(E,"mouseup",function(){NL.UI.div_button_pressed(C,E,0,B,A)},false);xAddEventListener(E,"mouseout",function(){NL.UI.div_button_pressed(C,E,0,B,A)},false);if(NL.Browser.Detect.isIE){xAddEventListener(E,"dblclick",function(){NL.UI.div_button_pressed(C,E,2,B,A)},false)}}};NL.UI.div_button_pressed=function(D,G,C,B,A){var F=xGetElementById(G);if(F){var E=D+"-pressed";if(C==1){if(!xHasClass(F,E)){xAddClass(F,E);return true}}else{if(C==2){B(A);return true}else{if(xHasClass(F,E)){xRemoveClass(F,E);B(A);return true}}}}return false};NL.UI.div_button_pressed_OLD=function(D,H,C,B,A){var E=D+"-unpressed";var G=D+"-pressed";var F=xGetElementById(H);if(!F){return false}if(C==1){if(xHasClass(F,E)){xRemoveClass(F,E);xAddClass(F,G)}}else{if(C==2){B(A)}else{if(xHasClass(F,G)){xRemoveClass(F,G);xAddClass(F,E);B(A)}}}return false};NL.UI.input_allow_tab_OBJ_FOCUS=null;NL.UI.input_allow_tab_REMOVE_TAB=function(A){return A.replace(/(^|\\n)\\t/g,"\$1")};NL.UI.input_allow_tab_ADD_TAB=function(A){return A.replace(/(^|\\n)([\\t\\S])/g,"\$1\\t\$2")};NL.UI.input_allow_tab=function(A){if(A){var B=xGetElementById(A);if(B&&!B.is_TAB_ALLOWED){B.is_TAB_ALLOWED=true;B.is_TAB_PRESSED=false;if(NL.Browser.Detect.isIE){xAddEventListener(B,"keydown",function(H){if(window.event.keyCode==9){var G=document.selection.createRange();if(G.text.length>0){if(window.event.shiftKey){var E=NL.UI.input_allow_tab_REMOVE_TAB(G.text);G.text=E;if(E.length<=0){if(B.createTextRange){var C=0;var F=document.selection.createRange().duplicate();F.moveEnd("character",B.value.length);if(F.text==""){C=B.value.length}else{C=B.value.lastIndexOf(F.text)}if(B.createTextRange){var D=B.createTextRange();D.move("character",C);D.select()}}}}else{G.text=NL.UI.input_allow_tab_ADD_TAB(G.text)}}else{G.text="\\t"}return false}},false)}else{xAddEventListener(B,"keypress",function(H){if(H.keyCode==9){this.is_TAB_PRESSED=true;var C=this.scrollTop;var D=this.selectionStart;var F=this.selectionEnd;var I=this.value.substring(0,D);var J=this.value.substring(D,F);var G=this.value.substring(F,this.value.length);var K=false;if(J.length>0){K=true;if(H.shiftKey){J=NL.UI.input_allow_tab_REMOVE_TAB(J)}else{J=NL.UI.input_allow_tab_ADD_TAB(J)}}else{J="\\t"}this.value=I+J+G;this.focus();if(K){if(NL.Browser.Detect.isOPERA&&J.length<=0&&this.createTextRange){var E=this.createTextRange();E.move("character",D);E.select()}else{this.selectionStart=D;this.selectionEnd=D+J.length}}else{D++;this.selectionStart=D;this.selectionEnd=D}this.scrollTop=C;if(H.cancelable){H.preventDefault();H.stopPropagation()}}},false);if(!NL.Browser.Detect.isFF){xAddEventListener(B,"blur",function(C){if(this.is_TAB_PRESSED){this.is_TAB_PRESSED=false;NL.UI.inpu_allow_tab_OBJ_FOCUS=B;setTimeout("NL.UI.inpu_allow_tab_OBJ_FOCUS.focus()",1)}},false)}}}}};if(typeof WC=="undefined"){var WC={Other:{}}}else{WC.namespace("Other")}WC.Other.DATA={password_ENCODED:"",password_TMP:"_0_[PASS]_0_",last_ACTIVE:null};WC.Other.DIE=function(B){WC.Other.ERROR_ALERT(B);var A=xGetElementById(window);throw ((A&&A.Error)?new Error(message):message)};WC.Other.ERROR_ALERT=function(B){var A="Web Console JavaScript ERROR: '"+B+"'";alert(A)};WC.Other.set_focus=function(A){var B=xGetElementById(A);if(B){B.focus()}};WC.Other.set_cursor_position=function(B,C){if(B){if(typeof C=="undefined"||C<0){C=(B.value&&B.value.length)?B.value.length:0}if(B.createTextRange){var A=B.createTextRange();A.move("character",C);A.select()}else{if(B.selectionStart){B.focus();B.setSelectionRange(C,C);if(C==0){B.focus()}}}}};WC.Other.paste_at_active_INPUT=function(A,D){var B=0;if(WC.Other.DATA.last_ACTIVE!=null){var C=xGetElementById(WC.Other.DATA.last_ACTIVE);if(C){C.value=D;C.focus();B=1}}if(!B&&A){A.blur()}};WC.Other.paste_at_active_INPUT_activate=function(A){if(A){WC.Other.DATA.last_ACTIVE=A}};WC.Other.paste_at_active_INPUT_deactivate=function(){WC.Other.DATA.last_ACTIVE=null};WC.Other.set_encoded_password=function(A){if(A&&A!=""){var C=xGetElementById("_user_password_MAIN");var B=xGetElementById("_user_password_MAIN_confirm");if(C&&B){C.value=B.value=WC.Other.DATA.password_TMP;WC.Other.DATA.password_ENCODED=A}}};WC.Other.password_CHANGED=function(){if(WC.Other.DATA.password_ENCODED!=""){WC.Other.DATA.password_ENCODED=""}};WC.Other.password_ENCODE=function(A){if(WC.Other.DATA.password_ENCODED!=""&&A==WC.Other.DATA.password_TMP){return WC.Other.DATA.password_ENCODED}else{if(NL.Crypt.sha1_vm_test()){return NL.Crypt.sha1_hex(A)}else{WC.Other.ERROR_ALERT("Java Virtual Machine works incorrectly");return""}}};WC.Other.init=function(C){var A=xGetElementById("block-CONTENT");if(A){if(A.style){A.style.display="block";if(C){if(C=="logon"){WC.Other.logon_init()}else{if(C=="install"){var B=xGetElementById("_user_login_MAIN");if(B){B.focus()}}}}return 1}}return 0};WC.Other.logon_init=function(){var B=xGetElementById("_user_login_MAIN");if(B){var C=xGetElementById("_user_password_MAIN");if(B.value==""){var A=xGetCookie("WC_user_login");if(A&&A!="null"&&A!=""){B.value=A;if(C){C.focus()}else{B.focus();WC.Other.set_cursor_position(B,B.value.length)}}else{B.focus()}}else{if(C){C.focus()}}}};WC.Other.cookie_SET_LOGIN=function(B){if(B&&B!=""){var A=new Date();var D=A.getTime();var C=30*86400000;A.setTime(D+C);xSetCookie("WC_user_login",B,A)}};WC.Other.CHECK_email=function(A){if(A&&A!=""){if(A.indexOf("@")>0&&A.indexOf(".")>=0){return 1}}return 0};WC.Other.submit=function(E,D){if(E){if(E=="logon"){var B={user_login:{name:"Login",needed:1,func_HOOK:WC.Other.cookie_SET_LOGIN},user_password:{name:"Password",needed:1,func_ENCODE:WC.Other.password_ENCODE}};var A=WC.Other.submit_CHECK_FORM_and_SET(B);if(A){A.submit()}}else{if(E=="install"){var B={user_login:{name:"Administrator login",needed:1,func_HOOK:WC.Other.cookie_SET_LOGIN},user_password:{name:"Password",needed:1,confirm:1,func_ENCODE:WC.Other.password_ENCODE},user_email:{name:"E-Mail",needed:1,confirm:1,func_CHECK:WC.Other.CHECK_email}};var C=xGetElementById("_use_ENCODINGS_switcher");if(D&&C&&C.checked){B.encoding_SERVER_CONSOLE={name:"Server console encoding",needed:0};B.encoding_SERVER_SYSTEM={name:"Server system encoding",needed:0};B.encoding_EDITOR_TEXT={name:"Text editor encoding:",needed:0}}var A=WC.Other.submit_CHECK_FORM_and_SET(B);if(A){A.submit()}}}}return false};WC.Other.submit_CHECK_FORM_and_SET=function(B){var A=xGetElementById("form-MAIN");var C=xGetElementById("form-HIDDEN");if(!A){WC.Other.ERROR_ALERT("Unable to find 'form-MAIN' object");return 0}else{if(!C){WC.Other.ERROR_ALERT("Unable to find 'form-HIDDEN' object");return 0}else{for(var G in B){var F=xGetElementById("_"+G+"_MAIN");var D=xGetElementById("_"+G);if(!F){WC.Other.ERROR_ALERT('Unable to find "_'+G+'_MAIN" object');return 0}else{if(!D){WC.Other.ERROR_ALERT('Unable to find "_'+G+'" object');return 0}else{if(F.value&&F.value!=""){if(B[G]["func_CHECK"]){if(!B[G]["func_CHECK"](F.value)){alert('"'+B[G]["name"]+'" is incorrect, please fix it...');F.focus();return 0}}if(B[G]["confirm"]){var E=xGetElementById("_"+G+"_MAIN_confirm");if(E){if(E.value&&E.value!=""){if(E.value!=F.value){alert('"'+B[G]["name"]+'" and "Confirm '+B[G]["name"].toLowerCase()+'" are not the same, please fill that fields again...');F.focus();return 0}}else{alert('"Confirm '+B[G]["name"].toLowerCase()+"\\" can't be empty, please fill that field...");E.focus();return 0}}else{WC.Other.ERROR_ALERT('Unable to find "_'+G+'_MAIN_confirm" object');return 0}}if(B[G]["func_HOOK"]){B[G]["func_HOOK"](F.value)}if(B[G]["func_ENCODE"]){D.value=B[G]["func_ENCODE"](F.value);if(D.value==""){return 0}}else{D.value=F.value}}else{if(B[G]["needed"]){alert('"'+B[G]["name"]+"\\" can't be empty, please fill that field...");F.focus();return 0}}}}}return C}}return 0};
//--></script>
</head>
<!-- 'onload' will show MAIN block for JS-enabled browsers, get login from cookies and set focus to the needed element -->
<body onload="WC.Other.init('$WC_HTML{'PAGE_TYPE'}')">
<table id="layout"><tr><td id="layout-td">
		<!-- JS IS NOT SUPPORTED -->
		<noscript>
			<div id="block-no-JS">
				Your browser does not support JavaScript.<br />
				To use Web Console, your browser must support JavaScript.<br />
				<div id="block-no-JS-FAQ">
					&#187; read solution for that problem at
					<a href="http://www.web-console.org/faq/#INSTALL_JS_NOT_FOUND" target="_blank" title="Read solution for that problem">Web Console FAQ</a>
				</div>
			</div>
		</noscript>
		<!-- THAT BLOCK WILL BE VISIBLE ONLY AT JS-ENABLED BROWSERS -->
		<div id="block-CONTENT">
			<!-- main 'title' and 'info' -->
			<table id="block-main">
				<tr><td id="block-main-title">$WC_HTML{'main_title'}</td></tr>
				<tr><td id="block-main-info">$WC_HTML{'main_info'}</td></tr>
			</table>
			<!-- PARTS OF DIFFERENT PAGES -->
_HTML_CODE_EOF
if($WC_HTML{'PAGE_TYPE'}eq 'logon'){print <<_HTML_CODE_EOF;
			<form id="form-HIDDEN" action="$WC_HTML{'APP_file'}" method="post">
				<input type="hidden" id="_q_action" name="q_action" value="logon" />
				<input type="hidden" id="_user_login" name="user_login" value="" />
				<input type="hidden" id="_user_password" name="user_password" value="" />
			</form>
			<form id="form-MAIN" action="" method="post" onsubmit="WC.Other.submit('logon'); return false">
			<table id="block-FORM">
				<tr><td class="form-label">login:</td><td class="form-input"><input id="_user_login_MAIN" name="user_login_MAIN" type="text" value="$WC_HTML{'user_login'}" /></td></tr>
				<tr><td class="form-label">password:</td><td class="form-input"><input id="_user_password_MAIN" name="user_password_MAIN" type="password" value="$WC_HTML{'user_password'}" /></td></tr>
				<tr><td class="form-submit-fake"><input type="submit" value="&nbsp;" /></td><td class="form-submit"><div id="div-button-submit" class="div-button-unpressed">enter</div></td></tr>
			</table>
			</form>
			<div id="block-footer"><a href="http://www.web-console.org/donate/" title="Support Web Console project" target="_blank">&gt; Support us &lt;</a></div>
			<script type="text/JavaScript"><!--
				NL.UI.div_button_register('div-button', 'div-button-submit', function() { WC.Other.submit('logon'); }, {});
			//--></script>
_HTML_CODE_EOF
}elsif($WC_HTML{'PAGE_TYPE'}eq 'error'){print <<_HTML_CODE_EOF;
				<!-- ERROR MESSAGE -->
_HTML_CODE_EOF
}elsif($WC_HTML{'PAGE_TYPE'}eq 'info'){print <<_HTML_CODE_EOF;
				<!-- INFORMATIONAL MESSAGE -->
_HTML_CODE_EOF
}elsif($WC_HTML{'PAGE_TYPE'}eq 'install'){print <<_HTML_CODE_EOF;
				<!-- INFORMATIONAL MESSAGE -->
_HTML_CODE_EOF
if($WC_HTML{'PAGE_ACTION'}eq 'ERROR'){print <<_HTML_CODE_EOF;
					<!-- INFORMATIONAL MESSAGE -->
_HTML_CODE_EOF
}else{print <<_HTML_CODE_EOF;
				<form id="form-HIDDEN" action="$WC_HTML{'APP_file'}" method="post">
					<input type="hidden" id="_q_action" name="q_action" value="install" />
					<input type="hidden" id="_user_login" name="user_login" value="" />
					<input type="hidden" id="_user_password" name="user_password" value="" />
					<input type="hidden" id="_user_email" name="user_email" value="" />
					<input type="hidden" id="_encoding_SERVER_CONSOLE" name="encoding_SERVER_CONSOLE" value="" />
					<input type="hidden" id="_encoding_SERVER_SYSTEM" name="encoding_SERVER_SYSTEM" value="" />
					<input type="hidden" id="_encoding_EDITOR_TEXT" name="encoding_EDITOR_TEXT" value="" />
				</form>
				<form id="form-MAIN" action="" method="post" onsubmit="WC.Other.submit('install', $WC_HTML{'ENCODE_ON'}); return false">
				<table id="block-FORM">
					<tr><td class="form-label">administrator login:</td><td class="form-input"><input id="_user_login_MAIN" name="user_login_MAIN" type="text" value="$WC_HTML{'user_login'}" onclick="WC.Other.paste_at_active_INPUT_deactivate()" /></td></tr>
					<tr><td class="form-label">password:</td><td class="form-input"><input id="_user_password_MAIN" name="user_password_MAIN" type="password" value="" onclick="WC.Other.paste_at_active_INPUT_deactivate()" /></td></tr>
					<tr><td class="form-label">confirm password:</td><td class="form-input"><input id="_user_password_MAIN_confirm" name="user_password_MAIN_confirm" type="password" value="$WC_HTML{'user_password'}" onclick="WC.Other.paste_at_active_INPUT_deactivate()" /></td></tr>
					<tr><td class="form-label">e-mail:</td><td class="form-input"><input id="_user_email_MAIN" name="user_email_MAIN" type="text" value="$WC_HTML{'user_email'}" onclick="WC.Other.paste_at_active_INPUT_deactivate()" /></td></tr>
					<tr><td class="form-label">confirm e-mail:</td><td class="form-input"><input id="_user_email_MAIN_confirm" name="user_email_MAIN_confirm" type="text" value="$WC_HTML{'user_email'}" onclick="WC.Other.paste_at_active_INPUT_deactivate()" /></td></tr>
_HTML_CODE_EOF
if($WC_HTML{'ENCODE_ON'}==1){print <<_HTML_CODE_EOF;
					<tr><td class="form-encoding" colspan="2">
						<table id="block-switcher">
							<tr>
								<td class="left"><input id="_use_ENCODINGS_switcher" name="use_ENCODINGS_switcher" type="checkbox" value="" /></td>
								<td class="right"><label id="_use_ENCODINGS_switcher-LABEL" for="_use_ENCODINGS_switcher">specify encodings</label></td>
							</tr>
						</table>
						<div id="_use_ENCODINGS_switcher-AREA" class="div-switcher-unpressed">
							<div class="t-encoding">Please specify encodings at POSIX format</div>
							<div class="t-encoding-example">
								Examples: &quot;<span class="t-encoding-marked"><a href="#" onclick="WC.Other.paste_at_active_INPUT(this, 'UTF-8'); return false" title="Click to paste at active (or last active) encodings input">UTF-8</a></span>&quot;, &quot;<span class="t-encoding-marked"><a href="#" onclick="WC.Other.paste_at_active_INPUT(this, 'ru_RU.KOI8-R'); return false" title="Click to paste at active (or last active) encodings input">ru_RU.KOI8-R</a></span>&quot;,<br />
								&quot;<span class="t-encoding-marked"><a href="#" onclick="WC.Other.paste_at_active_INPUT(this, 'ru_RU.CP1251'); return false" title="Click to paste at active (or last active) encodings input">ru_RU.CP1251</a></span>&quot;, &quot;<span class="t-encoding-marked"><a href="#" onclick="WC.Other.paste_at_active_INPUT(this, 'ru_RU.CP866'); return false" title="Click to paste at active (or last active) encodings input">ru_RU.CP866</a></span>&quot;...
							</div>
							<div class="t-encoding-read-link">About Web Console encodings please read <a class="underline" href="http://www.web-console.org/faq/#ENCODINGS_HOWTO" title="Read detailed information about setting Web Console encodings" target="_blank">here</a></div>
							<table id="block-switcher-ENCODING">
								<tr><td class="form-encoding-label" title="Encoding of server shell commands execution output (like 'ls', 'dir'...)">server console encoding:</td></tr>
								<tr><td class="form-encoding-input"><input id="_encoding_SERVER_CONSOLE_MAIN" name="encoding_SERVER_CONSOLE_MAIN" type="text" value="$WC_HTML{'encoding_SERVER_CONSOLE'}" onfocus="WC.Other.paste_at_active_INPUT_activate(this)" /></td></tr>
								<tr><td class="form-encoding-label" title="Encoding of server internal commands (programming commands) output">server system encoding:</td></tr>
								<tr><td class="form-encoding-input"><input id="_encoding_SERVER_SYSTEM_MAIN" name="encoding_SERVER_SYSTEM_MAIN" type="text" value="$WC_HTML{'encoding_SERVER_SYSTEM'}" onfocus="WC.Other.paste_at_active_INPUT_activate(this)" /></td></tr>
								<tr><td class="form-encoding-label" title="Encoding for Web Console text files editor (if empty then will be used &quot;server system&quot;)">Web Console text editor encoding:</td></tr>
								<tr><td class="form-encoding-input"><input id="_encoding_EDITOR_TEXT_MAIN" name="encoding_EDITOR_TEXT_MAIN" type="text" value="$WC_HTML{'encoding_EDITOR_TEXT'}" onfocus="WC.Other.paste_at_active_INPUT_activate(this)" /></td></tr>
							</table>
							<div id="block-ENCODINGS_TITLE">Common encodings list (click to paste):</div>
							<div id="block-ENCODINGS_LIST">$WC_HTML{'ENCODE_ENCODING'}</div>
						</div>
					</td></tr>
					<script type="text/JavaScript"><!--
						NL.UI.switcher_register('div-switcher', '_use_ENCODINGS_switcher', $WC_HTML{'ENCODE_AREA_SHOW'});
						// Feature for setting encrypted password (not used now):
						// Add to password input: 'onchange="WC.Other.password_CHANGED(); return true"'
						// Call when form is shown: WC.Other.set_encoded_password('$WC_HTML{'user_password'}')
					//--></script>
_HTML_CODE_EOF
}print <<_HTML_CODE_EOF;
					<tr><td class="form-submit-fake"><input type="submit" value="&nbsp;" /></td><td class="form-submit"><div id="div-button-submit" class="div-button-unpressed">install</div></td></tr>
				</table>
				</form>
_HTML_CODE_EOF
if($WC_HTML{'ENCODE_ON'}==0){print <<_HTML_CODE_EOF;
					$WC_HTML{'ENCODE_ERROR'}
_HTML_CODE_EOF
}print <<_HTML_CODE_EOF;
				<script type="text/JavaScript"><!--
					NL.UI.div_button_register('div-button', 'div-button-submit', function() { WC.Other.submit('install', $WC_HTML{'ENCODE_ON'}); }, {});
				//--></script>
_HTML_CODE_EOF
}print <<_HTML_CODE_EOF;
_HTML_CODE_EOF
}print <<_HTML_CODE_EOF;
		</div>
		<!-- END OF THE BLOCK THAT IS VISIBLE ONLY AT JS-ENABLED BROWSERS -->
	</td>
</tr>
</table>
</body>
</html>

_HTML_CODE_EOF
}elsif($in_ID eq 'page_console'){$WC_HTML{'__CSS__'}=&_get_CSS($in_ID);
print <<_HTML_CODE_EOF;
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
	<!-- WEB CONSOLE HTML :: MAIN PAGE (CONSOLE) -->
	<!-- (C) 2008 Nickolay Kovalev, http://resume.nickola.ru -->
	<!-- Web Console URL: http://www.web-console.org -->
	<!-- Last version of Web Console can be downloaded from: http://www.web-console.org/download/ -->
	<!-- Web Console Group services: http://services.web-console.org -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="author" content="Nickolay Kovalev | http://resume.nickola.ru" />
	<meta name="robots" content="NONE" />
	<title>$WC_HTML{'page_title'}</title>
<style type="text/css" media="all">
*{margin:0;padding:0;background-color:#000;font-weight:normal;font-size:$WC_HTML{'STYLE_CONSOLE_FONT_SIZE'};font-family:$WC_HTML{'STYLE_CONSOLE_FONT_FAMILY'};color:$WC_HTML{'STYLE_CONSOLE_FONT_COLOR'};}a,a:visited,a:active,a:hover{background-color:#000;color:#bbb;text-decoration:underline;}html,body{margin:0;padding:0;height:100%;}html{overflow-y:scroll;}div{margin:0;padding:0;}form{margin:0;padding:0;}.hide{display:none;}.show{display:block;}.grid{border-collapse:collapse;margin:0;border:0;width:auto;}.grid td{margin:0;padding:0;}#layout{width:100%;height:100%;border:0;border-collapse:collapse;}#layout-td{vertical-align:bottom;text-align:left;margin:0;padding:6px;}#layout-internal{width:100%;border:0;border-collapse:collapse;}#area-output{margin:0;padding:0;vertical-align:bottom;text-align:left;height:auto;}#area-bottom{margin:0;padding:0;vertical-align:bottom;text-align:left;height:20px;}#area-bottom .grid{width:100%;}#area-command-prefix-td{margin:0;padding:0;vertical-align:middle;text-align:left;width:auto;height:20px;white-space:nowrap;}#area-command-prefix{margin:0;padding:0;vertical-align:middle;white-space:nowrap;}#area-command{margin:0;padding:0;vertical-align:middle;text-align:left;width:100%;height:20px;}#input-query{margin:0;padding:0;padding:0 1px 0 0;vertical-align:middle;text-align:left;width:100%;border:0;outline:none;}.block-powered-by{margin-right:6px;color:#7d7d7d;text-align:right;vertical-align:top;}.block-powered-by a,.block-powered-by a:visited,.block-powered-by a:active,.block-powered-by a:hover{color:#7d7d7d;background-color:#000;text-decoration:none;}.block-message{margin:8px 0 6px 8px;color:#219860;text-align:left;vertical-align:top;}.block-message a,.block-message a:visited,.block-message a:active,.block-message a:hover{color:#b48c00;background-color:#000;text-decoration:underline;}.block-cmd{margin:0;padding:0;}.block-cmd-command{margin:0;padding:0;}.block-cmd-result{margin:0;padding:0;}.block-error{margin:0 0 0 16px;padding:0;color:#e25120;}.t-blue,.t-title{color:#1196cb;}.t-green,.t-message{color:#219860;}.t-green-light{color:#528c6a;}.t-brown,.t-link,.t-cmd,.t-mark,.s-link{color:#b48c00;}.t-brown-light{color:#b66640;}a.t-cmd,a.t-cmd:visited,a.t-cmd:active,a.t-cmd:hover{color:#b48c00;text-decoration:none;}a.t-link-notUL,a.t-link-notUL:visited,a.t-link-notUL:active,a.t-link-notUL:hover{color:#b48c00;text-decoration:none;}.t-yellow,.t-dash{color:#aeac0d;}.t-grey,.t-wait,.t-timer{color:#7d7d7d;}.t-red{color:#e51b16;}.t-red-light,.t-alert{color:#e25120;}.t-red-dark{color:#ca412d;}.t-lime{color:#00cd00;}.t-author{color:#ca412d;}a.a-no-line,a.a-no-line:visited,a.a-no-line:active,a.a-no-line:hover{text-decoration:none;}a.a-brown,a.a-brown:visited,a.a-brown:active,a.a-brown:hover{color:#b48c00;}.report-LAYOUT{padding:0;margin:0 auto;width:auto;border:0;border-collapse:collapse;text-align:center;}.report-LAYOUT td{text-align:left;}.report-SPLITTER{padding:0 0 8px 0;margin:8px 0 0 0;border-top:1px dashed #48736c;font-size:1px;}.report-title-ERROR,.report-title-WARNING,.report-title-INFORMATION{padding:0;margin:3px 6px 8px 0;font-size:14px;font-weight:bold;text-align:left;color:#1196cb;white-space:nowrap;}.report-MAIN{padding:8px 0 8px 0;margin:0;text-align:left;border-top:2px solid #48736c;border-bottom:2px solid #48736c;width:520px;line-height:120%;color:#aeac0d;}.report-MAIN a.m-bold,.report-MAIN a.m-bold:visited,.report-MAIN a.m-bold:active,.report-MAIN a.m-bold:hover{color:#aeac0d;font-weight:bold;text-decoration:underline;}.report-MAIN b{color:#aeac0d;font-weight:bold;}.report-FOOTER,.report-FOOTER b{padding:0;margin:6px 0 6px 0;white-space:nowrap;text-align:center;color:#00bc58;}.report-FOOTER b{font-weight:bold;}.report-FOOTER a,.report-FOOTER a:visited,.report-FOOTER a:active,.report-FOOTER a:hover{color:#00bc58;}.report-t-ERROR{color:#e51b16;font-weight:bold;}.report-t-WARNING{color:#00ab81;font-weight:bold;}.report-t-INFORMATION{color:#00ab81;font-weight:bold;}.report-b-INFO{padding:4px 0 0 0;margin:0;color:#b66712;}.report-b-INFO b{color:#b66712;font-weight:bold;}.report-b-FAQ{padding:0;margin:1px 0 0 0;white-space:nowrap;text-align:right;font-size:11px;color:#a995cd;}.report-b-FAQ a,.report-b-FAQ a:visited,.report-b-FAQ a:active,.report-b-FAQ a:hover{font-size:11px;color:#a995cd;}.report-block-MOD_PERL-code{margin:0;padding:3px 8px 0 22px;}.report-block-MOD_PERL-code pre{font-family:Courier New,Courier,Fixed;font-size:13px;color:#960;padding:0;margin:0;}.report-variable-name,.report-variable-name a,.report-variable-name a:visited,.report-variable-name a:active,.report-variable-name a:hover{color:#b66712;font-weight:bold;}.report-variable-name a,.report-variable-name a:visited,.report-variable-name a:active,.report-variable-name a:hover{text-decoration:none;}.report-dash{color:#aeac0d;font-weight:bold;}.custom-report-TITLE{margin:0 0 6px 32px;color:#00cd00;}.report-MAIN{width:600px;}.report-LAYOUT{margin:0 0 0 32px;}.report-title-ERROR,.report-title-WARNING,.report-title-INFORMATION{display:none;}.report-t-ERROR,.report-t-WARNING,.report-t-INFORMATION,.report-variable-name,.report-variable-name a,.report-variable-name a:visited,.report-variable-name a:active,.report-variable-name a:hover,.report-dash{font-weight:normal;}.wc-ui-tab{width:1%;font-family:verdana,helvetica,arial,sans-serif;border-collapse:collapse;margin:6px 16px;border:0;border-left:1px solid #b48c00;border-bottom:1px solid #b48c00;}.wc-ui-tab *{color:#b3b3b3;font-family:verdana,helvetica,arial,sans-serif;}.wc-ui-tab-top{border:0;padding:0;height:1%;vertical-align:bottom;text-align:left;}.wc-ui-tab-top .grid{width:100%;}.grid td.wc-ui-tab-title,.grid td.wc-ui-tab-title-menu{width:1%;white-space:nowrap;border:0;border-top:1px solid #b48c00;border-right:1px solid #b48c00;padding:6px 10px;vertical-align:middle;font-weight:bold;color:#b48c00;}.grid td.wc-ui-tab-title-menu{border-bottom:1px solid #655b53;}.grid td.wc-ui-tab-title-center{border:0;border-bottom:1px solid #b48c00;font-size:1px;padding:0;width:100%;text-align:center;}.grid td.wc-ui-tab-title-center-sub{width:100%;}.wc-ui-tab-main{height:auto;border:0;border-right:1px solid #b48c00;vertical-align:middle;padding:10px 10px;margin:0;}.wc-ui-tab-bottom{border-right:1px solid #b48c00;padding:0 10px 8px 10px;margin:0;}.wc-ui-tab-menu{border-right:1px solid #b48c00;vertical-align:middle;padding:0;margin:0;background-color:#333;}.wc-ui-tab-menu .grid{width:100%;background-color:#333;}.wc-ui-tab-menu .grid td{cursor:pointer;padding:2px 10px 4px 10px;width:auto;background-color:#333;}.wc-ui-tab-menu .grid td span{white-space:nowrap;background-color:#333;color:#b48c00;text-decoration:underline;}.wc-ui-tab-menu .grid td.wc-ui-tab-menu-element-ACTIVE{cursor:default;background-color:#000;}.wc-ui-tab-menu .grid td.wc-ui-tab-menu-element-ACTIVE span{background-color:#000;color:#b48c00;text-decoration:none;}.wc-ui-tab-menu .grid .wc-ui-tab-menu-element-space{cursor:default;width:100%;font-size:1px;padding:0;}.wc-ui-open-container{border-collapse:collapse;margin:6px 6px 6px 16px;border:1px solid #6a7070;}.wc-ui-open-container-title{padding:3px 6px;border-bottom:1px solid #6a7070;}.wc-ui-open-container-main{padding:6px;}.grid .disabled{color:#6a7070;}a.link,a.link:visited,a.link:active,a.link:hover{color:#b66640;}a.link-warning,a.link-warning:visited,a.link-warning:active,a.link-warning:hover{color:#ca412d;}.grid .area-main,.grid .area-tabbed,.grid .area-top,.grid .area-bottom,.grid .area-left,.grid .area-left-short,.grid .area-right,.grid .area-right-long{text-align:left;vertical-align:middle;padding:2px 0 2px 0;}.grid .area-tabbed{padding-left:14px;}.grid .area-top{padding-bottom:9px;}.grid .area-bottom{padding-top:9px;}.grid .area-left{padding-right:6px;}.grid .area-left-short{padding-right:6px;width:auto;}.grid .area-left-short span{white-space:nowrap;}.grid .area-right-long{width:100%;}.grid .area-info-left{padding:0 0 3px 0;color:#528c6a;text-align:left;width:50%;}.grid .area-info-right{padding:0 0 3px 0;color:#528c6a;text-align:right;width:50%;}.grid .area-info-left span,.grid .area-info-right span{color:#b66640;white-space:nowrap;}.grid .area-info-left span.span-file-message{color:#1196cb;white-space:nowrap;}.area-info-right span.span-message{color:#00cd00;white-space:nowrap;}.grid .area-button-left,.grid .area-button-right{vertical-align:middle;padding:8px 0 2px 0;}.grid .area-button-right{padding-left:6px;}.grid .s-info{color:#219860;font-style:italic;}.grid .s-group-name,.grid .s-group-name span{color:#1196cb;font-weight:bold;}.grid .s-message{color:#528c6a;}.grid .s-name{color:#4fa600;}.grid .s-warning{color:#ca412d;}.grid .s-warning-text{color:#00cd00;}.grid .s-link{color:#b66640;}.grid .s-comment{color:#b69605;}.grid .s-note{font-size:9pt;font-style:italic;}.grid .in-text{padding:1px 3px;width:200px;border:1px solid #b3b3b3;vertical-align:middle;}.grid .in-checkbox,.grid .in-radio{background-color:#000;width:auto;height:auto;padding:0;margin:0 4px 0 0;}.grid select{width:200px;vertical-align:middle;}.grid textarea{padding:1px 0 0 3px;width:200px;height:80px;border:1px solid #b3b3b3;vertical-align:middle;overflow:auto;}* .div-button{cursor:default;margin:0;padding:2px 8px;text-align:center;background-color:#333;border:1px solid #bbb;}* .div-button-pressed{padding:3px 7px 1px 9px;}* .div-buttons-splitter{cursor:default;margin:0;padding:2px 0;text-align:center;color:#999;background-color:#333;border:1px solid #333;}.w-80,.grid .w-80{width:80px;}.w-90,.grid .w-90{width:90px;}.w-100,.grid .w-100{width:100px;}.w-120,.grid .w-120{width:120px;}.w-130,.grid .w-130{width:130px;}.w-140,.grid .w-140{width:140px;}.w-150,.grid .w-150{width:150px;}.w-200,.grid .w-200{width:200px;}.w-250,.grid .w-250{width:250px;}.w-270,.grid .w-270{width:270px;}.w-300,.grid .w-300{width:300px;}.w-400,.grid .w-400{width:400px;}.w-500,.grid .w-500{width:500px;}.w-600,.grid .w-600{width:600px;}.grid .wc-ui-fm-block{padding:3px 6px;vertical-align:top;cursor:default;white-space:nowrap;}.grid .wc-ui-fm-block div,.grid .wc-ui-fm-block div.free{padding:0 6px;white-space:nowrap;}.grid .wc-ui-fm-block div.wc-ui-fm-element-ACTIVE{background-color:#333;}.grid .wc-ui-fm-block div.file{color:#409732;}.grid .wc-ui-fm-block div.dir{color:#c26d45;}.grid .wc-ui-fm-block div.back{color:#c26d45;}.grid .wc-ui-fm-block div.empty{color:#6a7070;}.grid .wc-ui-fm-block-EMPTY{color:#6a7070;padding:0 6px;vertical-align:top;cursor:default;white-space:nowrap;}.iframe-download{width:1px;height:1px;display:none;}.grid .wc-ui-fm-path-text{padding:0 6px 0 0;color:#528c6a;width:1%;}.grid .wc-ui-fm-path-input{padding:0 6px 0 0;width:99%;}.grid .wc-ui-fm-path-button-GO{padding:0 6px 0 3px;width:auto;}.grid .wc-ui-fm-path-button-UP{padding:0;width:auto;}.grid .wc-ui-fm-info-left{padding:4px 0 2px 0;color:#528c6a;width:50%;text-align:left;}.grid .wc-ui-fm-info-right{padding:4px 0 2px 0;color:#528c6a;width:50%;text-align:right;}.grid .wc-ui-fm-info-left span,.grid .wc-ui-fm-info-right span{color:#b66640;}.grid .wc-ui-fm-info-right span.span-message{color:#00cd00;white-space:nowrap;}.grid .wc-ui-fm-listing{padding:2px 0;height:auto;border:1px solid #6a7070;overflow:auto;overflow-y:hidden;overflow-x:scroll;}.grid .wc-upload-files{padding:6px 0 4px 0;vertical-align:middle;}.grid .wc-upload-name{color:#528c6a;}.grid .wc-upload-area-select-left{padding:0 6px 0 0;vertical-align:middle;white-space:nowrap;}.grid .wc-upload-area-select-right{padding:0;vertical-align:middle;white-space:nowrap;}.grid .wc-upload-info-left{padding:2px 0 2px 0;color:#528c6a;width:50%;text-align:left;}.grid .wc-upload-info-right{padding:2px 0 2px 0;color:#528c6a;width:50%;text-align:right;}.grid .wc-upload-info-left span,.grid .wc-upload-info-right span{color:#b66640;}.grid .wc-upload-info-right span.span-message{color:#00cd00;white-space:nowrap;}.wc-upload-div-button-pressed,.wc-upload-div-button-unpressed,.wc-upload-div-button-dir-reload-pressed,.wc-upload-div-button-dir-reload-unpressed,.wc-upload-div-button-unpressed-hidden{margin:0;padding:2px 6px;width:120px;background-color:#333;text-align:center;vertical-align:middle;border:1px solid #bbb;cursor:default;}.wc-upload-div-button-pressed{padding:3px 5px 1px 7px;}.wc-upload-div-button-unpressed-hidden{display:none;}.wc-upload-div-button-unactive{color:#666;}.wc-upload-div-button-dir-reload{width:178px;font-size:9pt;height:14px;vertical-align:middle;cursor:default;margin:0;padding:2px 8px 2px 8px;text-align:center;background-color:#333;border:1px solid #bbb;}.wc-upload-div-button-dir-reload-pressed{padding:3px 7px 1px 9px;}.grid .wc-upload-small-info{font-size:11px;color:#6a7070;}.grid .wc-upload-dir-reload-status{font-weight:bold;padding:0;text-align:left;vertical-align:middle;}.grid .wc-upload-input-select{padding:0;margin:auto;border:1px solid #b3b3b3;width:auto;}.wc-upload-input,.wc-upload-input-permissions,.wc-upload-input-dir{padding:1px 3px 1px 3px;margin:auto;border:1px solid #b3b3b3;width:220px;}.wc-upload-input-file,.wc-upload-input-file-opera,.wc-upload-input-file-ff3{padding:1px 2px;margin:0;margin-bottom:5px;border:1px solid #b3b3b3;width:100%;}.grid .wc-upload-input-file-opera{background-color:#fff;color:#000;font-size:9pt;}.grid .wc-upload-input-file-ff3{background-color:#fff;color:#000;}.wc-upload-input-permissions{width:60px;}.wc-upload-input-dir{width:580px;}.wc-upload-checkbox-ASCII{padding:0;margin:0;}.grid .wc-upload-NO-RESULT{color:#00cd00;}.grid .wc-upload-total-files{color:#00cd00;}.grid .wc-upload-files-size{color:#00cd00;}.grid .wc-upload-time{color:#00cd00;}.grid .wc-upload-chmod{color:#00cd00;}.grid .wc-upload-file-good{color:#1196cb;}.grid .wc-upload-file-good-main{color:#069;}.grid .wc-upload-file-good-size{color:#069;}.grid .wc-upload-file-good-info{color:#666;font-style:italic;}.grid .wc-upload-file-bad{color:#ca412d;}.grid .wc-upload-file-bad-main{color:#930;}.grid .wc-upload-file-bad-size{color:#930;}.grid .wc-upload-file-bad-info{color:#666;font-style:italic;}.grid .wc-upload-STOPED{color:#ca412d;}.grid .wc-upload-progress{border-collapse:collapse;margin:0;border:0;width:100%;}.grid .wc-upload-progress-td-percents{font-weight:bold;font-size:13px;padding:3px 6px;text-align:center;color:#b69605;}.grid .wc-upload-progress-td-percents span{font-weight:bold;font-size:13px;color:#b69605;}.grid .wc-upload-progress-td-bar{font-weight:bold;font-size:13px;padding:3px 6px 9px 6px;text-align:center;}.grid .wc-upload-progress-td-approx{white-space:nowrap;font-size:13px;padding:3px 6px 5px 6px;text-align:center;color:#1196cb;}.grid .wc-upload-progress-td-approx span{font-size:13px;color:#1196cb;}.grid .wc-upload-progress-td-approx span.wc-upload-loading{color:#7d7d7d;}.grid .wc-upload-progress-div-bar{border:1px solid #a3a3a3;margin:auto;text-align:left;vertical-align:middle;width:90%;height:12px;background-color:#231f20;font-size:1px;}.grid .wc-upload-progress-div-subbar{text-align:left;font-size:1px;background-color:#c9c9c9;width:0;height:12px;}.grid .wc-upload-loading{color:#7d7d7d;}.grid .wc-upload-finish-info,.wc-upload-progress-info{border-collapse:collapse;padding:3px 0;margin:0;border:0;vertical-align:middle;width:100%;}.grid .wc-upload-finish-info td,.wc-upload-progress-info td{border:1px solid #b3b3b3;}.grid .wc-upload-finish-info td.finish-left,.wc-upload-progress-info td.progress-left{padding:3px 6px;width:1%;white-space:nowrap;vertical-align:middle;color:#528c6a;}.grid .wc-upload-finish-info td.finish-main,.wc-upload-progress-info td.progress-main{padding:3px 6px;width:100%;vertical-align:middle;color:#4fa600;}
</style>
<script type="text/javascript" language="JavaScript"><!--
xLibrary={version:"4.17",license:"GNU LGPL",url:"http://cross-browser.com/"};function xAddClass(B,C){if((B=xGetElementById(B))!=null){var A="";if(B.className.length&&B.className.charAt(B.className.length-1)!=" "){A=" "}if(!xHasClass(B,C)){B.className+=A+C;return true}}return false}function xAddEventListener(D,C,B,A){if(!(D=xGetElementById(D))){return }C=C.toLowerCase();if(D.addEventListener){D.addEventListener(C,B,A||false)}else{if(D.attachEvent){D.attachEvent("on"+C,B)}else{var E=D["on"+C];D["on"+C]=typeof E=="function"?function(F){E(F);B(F)}:B}}}function xCamelize(B){var C,E,A=B.split("-");var D=A[0];for(C=1;C<A.length;++C){E=A[C].charAt(0);D+=A[C].replace(E,E.toUpperCase())}return D}function xClientHeight(){var B=0,C=document,A=window;if((!C.compatMode||C.compatMode=="CSS1Compat")&&!A.opera&&C.documentElement&&C.documentElement.clientHeight){B=C.documentElement.clientHeight}else{if(C.body&&C.body.clientHeight){B=C.body.clientHeight}else{if(xDef(A.innerWidth,A.innerHeight,C.width)){B=A.innerHeight;if(C.width>A.innerWidth){B-=16}}}}return B}function xClientWidth(){var B=0,C=document,A=window;if((!C.compatMode||C.compatMode=="CSS1Compat")&&!A.opera&&C.documentElement&&C.documentElement.clientWidth){B=C.documentElement.clientWidth}else{if(C.body&&C.body.clientWidth){B=C.body.clientWidth}else{if(xDef(A.innerWidth,A.innerHeight,C.height)){B=A.innerWidth;if(C.height>A.innerHeight){B-=16}}}}return B}function xDef(){for(var A=0;A<arguments.length;++A){if(typeof (arguments[A])=="undefined"){return false}}return true}function xDocSize(){var G=document.body,F=document.documentElement;var I=0,C=0,A=0,E=0,D=0,J=0,H=0,B=0;if(F){I=F.scrollWidth;C=F.offsetWidth;D=F.scrollHeight;J=F.offsetHeight}if(G){A=G.scrollWidth;E=G.offsetWidth;H=G.scrollHeight;B=G.offsetHeight}return{w:Math.max(I,C,A,E),h:Math.max(D,J,H,B)}}function xGetComputedStyle(F,E,C){if(!(F=xGetElementById(F))){return null}var D,A="undefined",B=document.defaultView;if(B&&B.getComputedStyle){D=B.getComputedStyle(F,"");if(D){A=D.getPropertyValue(E)}}else{if(F.currentStyle){A=F.currentStyle[xCamelize(E)]}else{return null}}return C?(parseInt(A)||0):A}function xGetElementById(A){if(typeof (A)=="string"){if(document.getElementById){A=document.getElementById(A)}else{if(document.all){A=document.all[A]}else{A=null}}}return A}function xHasClass(B,C){B=xGetElementById(B);if(!B||B.className==""){return false}var A=new RegExp("(^|\\\\s)"+C+"(\\\\s|\$)");return A.test(B.className)}function xHeight(G,E){if(!(G=xGetElementById(G))){return 0}if(xNum(E)){if(E<0){E=0}else{E=Math.round(E)}}else{E=-1}var D=xDef(G.style);if(G==document||G.tagName.toLowerCase()=="html"||G.tagName.toLowerCase()=="body"){E=xClientHeight()}else{if(D&&xDef(G.offsetHeight)&&xStr(G.style.height)){if(E>=0){var F=0,C=0,B=0,H=0;if(document.compatMode=="CSS1Compat"){var A=xGetComputedStyle;F=A(G,"padding-top",1);if(F!==null){C=A(G,"padding-bottom",1);B=A(G,"border-top-width",1);H=A(G,"border-bottom-width",1)}else{if(xDef(G.offsetHeight,G.style.height)){G.style.height=E+"px";F=G.offsetHeight-E}}}E-=(F+C+B+H);if(isNaN(E)||E<0){return }else{G.style.height=E+"px"}}E=G.offsetHeight}else{if(D&&xDef(G.style.pixelHeight)){if(E>=0){G.style.pixelHeight=E}E=G.style.pixelHeight}}}return E}function xNum(){for(var A=0;A<arguments.length;++A){if(isNaN(arguments[A])||typeof (arguments[A])!="number"){return false}}return true}function xRemoveClass(A,B){if(!(A=xGetElementById(A))){return false}A.className=A.className.replace(new RegExp("(^|\\\\s)"+B+"(\\\\s|\$)","g"),function(E,D,C){return(D==" "&&C==" ")?" ":""});return true}function xScrollLeft(C,B){var D=0;if(!xDef(C)||B||C==document||C.tagName.toLowerCase()=="html"||C.tagName.toLowerCase()=="body"){var A=window;if(B&&C){A=C}if(A.document.documentElement&&A.document.documentElement.scrollLeft){D=A.document.documentElement.scrollLeft}else{if(A.document.body&&xDef(A.document.body.scrollLeft)){D=A.document.body.scrollLeft}}}else{C=xGetElementById(C);if(C&&xNum(C.scrollLeft)){D=C.scrollLeft}}return D}function xStr(B){for(var A=0;A<arguments.length;++A){if(typeof (arguments[A])!="string"){return false}}return true}function xWidth(F,B){if(!(F=xGetElementById(F))){return 0}if(xNum(B)){if(B<0){B=0}else{B=Math.round(B)}}else{B=-1}var D=xDef(F.style);if(F==document||F.tagName.toLowerCase()=="html"||F.tagName.toLowerCase()=="body"){B=xClientWidth()}else{if(D&&xDef(F.offsetWidth)&&xStr(F.style.width)){if(B>=0){var E=0,H=0,G=0,C=0;if(document.compatMode=="CSS1Compat"){var A=xGetComputedStyle;E=A(F,"padding-left",1);if(E!==null){H=A(F,"padding-right",1);G=A(F,"border-left-width",1);C=A(F,"border-right-width",1)}else{if(xDef(F.offsetWidth,F.style.width)){F.style.width=B+"px";E=F.offsetWidth-B}}}B-=(E+H+G+C);if(isNaN(B)||B<0){return }else{F.style.width=B+"px"}}B=F.offsetWidth}else{if(D&&xDef(F.style.pixelWidth)){if(B>=0){F.style.pixelWidth=B}B=F.style.pixelWidth}}}return B}function JsHttpRequest(){var t=this;t._NL_AJAX_STASH=null;t.onreadystatechange=null;t.readyState=0;t.responseText=null;t.responseXML=null;t.status=200;t.statusText="OK";t.responseJS=null;t.caching=false;t.loader=null;t.session_name="PHPSESSID";t._ldObj=null;t._reqHeaders=[];t._openArgs=null;t._errors={inv_form_el:"Invalid FORM element detected: name=%, tag=%",must_be_single_el:"If used, <form> must be a single HTML element in the list.",js_invalid:"JavaScript code generated by backend is invalid!\\n%",url_too_long:"Cannot use so long query with GET request (URL is larger than % bytes)",unk_loader:"Unknown loader: %",no_loaders:"No loaders registered at all, please check JsHttpRequest.LOADERS array",no_loader_matched:"Cannot find a loader which may process the request. Notices are:\\n%"};t.abort=function(){with(this){if(_ldObj&&_ldObj.abort){_ldObj.abort()}_cleanup();if(readyState==0){return }if(readyState==1&&!_ldObj){readyState=0;return }_changeReadyState(4,true)}};t.open=function(method,url,asyncFlag,username,password){with(this){if(url.match(/^((\\w+)\\.)?(GET|POST)\\s+(.*)/i)){this.loader=RegExp.\$2?RegExp.\$2:null;method=RegExp.\$3;url=RegExp.\$4}try{if(document.location.search.match(new RegExp("[&?]"+session_name+"=([^&?]*)"))||document.cookie.match(new RegExp("(?:;|^)\\\\s*"+session_name+"=([^;]*)"))){url+=(url.indexOf("?")>=0?"&":"?")+session_name+"="+this.escape(RegExp.\$1)}}catch(e){}_openArgs={method:(method||"").toUpperCase(),url:url,asyncFlag:asyncFlag,username:username!=null?username:"",password:password!=null?password:""};_ldObj=null;_changeReadyState(1,true);return true}};t.send=function(content){if(!this.readyState){return }this._changeReadyState(1,true);this._ldObj=null;var queryText=[];var queryElem=[];if(!this._hash2query(content,null,queryText,queryElem)){return }var hash=null;if(this.caching&&!queryElem.length){hash=this._openArgs.username+":"+this._openArgs.password+"@"+this._openArgs.url+"|"+queryText+"#"+this._openArgs.method;var cache=JsHttpRequest.CACHE[hash];if(cache){this._dataReady(cache[0],cache[1]);return false}}var loader=(this.loader||"").toLowerCase();if(loader&&!JsHttpRequest.LOADERS[loader]){return this._error("unk_loader",loader)}var errors=[];var lds=JsHttpRequest.LOADERS;for(var tryLoader in lds){var ldr=lds[tryLoader].loader;if(!ldr){continue}if(loader&&tryLoader!=loader){continue}var ldObj=new ldr(this);JsHttpRequest.extend(ldObj,this._openArgs);JsHttpRequest.extend(ldObj,{queryText:queryText.join("&"),queryElem:queryElem,id:(new Date().getTime())+""+JsHttpRequest.COUNT++,hash:hash,span:null});var error=ldObj.load();if(!error){this._ldObj=ldObj;JsHttpRequest.PENDING[ldObj.id]=this;return true}if(!loader){errors[errors.length]="- "+tryLoader.toUpperCase()+": "+this._l(error)}else{return this._error(error)}}return tryLoader?this._error("no_loader_matched",errors.join("\\n")):this._error("no_loaders")};t.getAllResponseHeaders=function(){with(this){return _ldObj&&_ldObj.getAllResponseHeaders?_ldObj.getAllResponseHeaders():[]}};t.getResponseHeader=function(label){with(this){return _ldObj&&_ldObj.getResponseHeader?_ldObj.getResponseHeader(label):null}};t.setRequestHeader=function(label,value){with(this){_reqHeaders[_reqHeaders.length]=[label,value]}};t._dataReady=function(text,js){with(this){if(caching&&_ldObj){JsHttpRequest.CACHE[_ldObj.hash]=[text,js]}responseText=responseXML=text;responseJS=js;if(js!==null){status=200;statusText="OK"}else{status=500;statusText="Internal Server Error"}_changeReadyState(2);_changeReadyState(3);_changeReadyState(4);_cleanup()}};t._l=function(args){var i=0,p=0,msg=this._errors[args[0]];while((p=msg.indexOf("%",p))>=0){var a=args[++i]+"";msg=msg.substring(0,p)+a+msg.substring(p+1,msg.length);p+=1+a.length}return msg};t._error=function(msg){msg=this._l(typeof (msg)=="string"?arguments:msg);if(typeof NL!="undefined"&&typeof NL.AJAX!="undefined"&&typeof NL.AJAX._JsHttpRequest_ERROR_THROW!="undefined"){NL.AJAX._JsHttpRequest_ERROR_THROW(msg,this._NL_AJAX_STASH);return false}else{msg="JsHttpRequest: "+msg;if(!window.Error){throw msg}else{if((new Error(1,"test")).description=="test"){throw new Error(1,msg)}else{throw new Error(msg)}}}};t._hash2query=function(content,prefix,queryText,queryElem){if(prefix==null){prefix=""}if((""+typeof (content)).toLowerCase()=="object"){var formAdded=false;if(content&&content.parentNode&&content.parentNode.appendChild&&content.tagName&&content.tagName.toUpperCase()=="FORM"){content={form:content}}for(var k in content){var v=content[k];if(v instanceof Function){continue}var curPrefix=prefix?prefix+"["+this.escape(k)+"]":this.escape(k);var isFormElement=v&&v.parentNode&&v.parentNode.appendChild&&v.tagName;if(isFormElement){var tn=v.tagName.toUpperCase();if(tn=="FORM"){formAdded=true}else{if(tn=="INPUT"||tn=="TEXTAREA"||tn=="SELECT"){}else{return this._error("inv_form_el",(v.name||""),v.tagName)}}queryElem[queryElem.length]={name:curPrefix,e:v}}else{if(v instanceof Object){this._hash2query(v,curPrefix,queryText,queryElem)}else{if(v===null){continue}if(v===true){v=1}if(v===false){v=""}queryText[queryText.length]=curPrefix+"="+this.escape(""+v)}}if(formAdded&&queryElem.length>1){return this._error("must_be_single_el")}}}else{queryText[queryText.length]=content}return true};t._cleanup=function(){var ldObj=this._ldObj;if(!ldObj){return }JsHttpRequest.PENDING[ldObj.id]=false;var span=ldObj.span;if(!span){return }ldObj.span=null;var closure=function(){span.parentNode.removeChild(span)};JsHttpRequest.setTimeout(closure,50)};t._changeReadyState=function(s,reset){with(this){if(reset){status=statusText=responseJS=null;responseText=""}readyState=s;if(onreadystatechange){onreadystatechange()}}};t.escape=function(s){return escape(s).replace(new RegExp("\\\\+","g"),"%2B")}}JsHttpRequest.COUNT=0;JsHttpRequest.MAX_URL_LEN=2000;JsHttpRequest.CACHE={};JsHttpRequest.PENDING={};JsHttpRequest.LOADERS={};JsHttpRequest._dummy=function(){};JsHttpRequest.TIMEOUTS={s:window.setTimeout,c:window.clearTimeout};JsHttpRequest.setTimeout=function(B,A){window.JsHttpRequest_tmp=JsHttpRequest.TIMEOUTS.s;if(typeof (B)=="string"){D=window.JsHttpRequest_tmp(B,A)}else{var D=null;var C=function(){B();delete JsHttpRequest.TIMEOUTS[D]};D=window.JsHttpRequest_tmp(C,A);JsHttpRequest.TIMEOUTS[D]=C}window.JsHttpRequest_tmp=null;return D};JsHttpRequest.clearTimeout=function(B){window.JsHttpRequest_tmp=JsHttpRequest.TIMEOUTS.c;delete JsHttpRequest.TIMEOUTS[B];var A=window.JsHttpRequest_tmp(B);window.JsHttpRequest_tmp=null;return A};JsHttpRequest.query=function(C,F,A,D,B){var E=new this();E.caching=!D;E.onreadystatechange=function(){if(E.readyState==4){A(E.responseJS,E.responseText)}};if(typeof B!="undefined"&&B){E._NL_AJAX_STASH=B}E.open(null,C,true);E.send(F)};JsHttpRequest.dataReady=function(B){var A=this.PENDING[B.id];delete this.PENDING[B.id];if(A){A._dataReady(B.text,B.js)}else{if(A!==false){if(typeof NL!="undefined"&&typeof NL.AJAX!="undefined"&&typeof NL.AJAX._JsHttpRequest_ERROR_THROW!="undefined"){NL.AJAX._JsHttpRequest_ERROR_THROW("dataReady(): unknown pending id: "+B.id,null)}else{throw"dataReady(): unknown pending id: "+B.id}}}};JsHttpRequest.extend=function(B,C){for(var A in C){B[A]=C[A]}};JsHttpRequest.LOADERS.xml={loader:function(req){JsHttpRequest.extend(req._errors,{xml_no:"Cannot use XMLHttpRequest or ActiveX loader: not supported",xml_no_diffdom:"Cannot use XMLHttpRequest to load data from different domain %",xml_no_headers:"Cannot use XMLHttpRequest loader or ActiveX loader, POST method: headers setting is not supported, needed to work with encodings correctly",xml_no_form_upl:"Cannot use XMLHttpRequest loader: direct form elements using and uploading are not implemented"});this.load=function(){if(this.queryElem.length){return["xml_no_form_upl"]}if(this.url.match(new RegExp("^([a-z]+://[^\\\\/]+)(.*)","i"))){if(RegExp.\$1.toLowerCase()!=document.location.protocol+"//"+document.location.hostname.toLowerCase()){return["xml_no_diffdom",RegExp.\$1]}}var xr=null;if(window.XMLHttpRequest){try{xr=new XMLHttpRequest()}catch(e){}}else{if(window.ActiveXObject){try{xr=new ActiveXObject("Microsoft.XMLHTTP")}catch(e){}if(!xr){try{xr=new ActiveXObject("Msxml2.XMLHTTP")}catch(e){}}}}if(!xr){return["xml_no"]}var canSetHeaders=window.ActiveXObject||xr.setRequestHeader;if(!this.method){this.method=canSetHeaders&&this.queryText.length?"POST":"GET"}if(this.method=="GET"){if(this.queryText){this.url+=(this.url.indexOf("?")>=0?"&":"?")+this.queryText}this.queryText="";if(this.url.length>JsHttpRequest.MAX_URL_LEN){return["url_too_long",JsHttpRequest.MAX_URL_LEN]}}else{if(this.method=="POST"&&!canSetHeaders){return["xml_no_headers"]}}this.url+=(this.url.indexOf("?")>=0?"&":"?")+"JsHttpRequest="+(req.caching?"0":this.id)+"-xml";var id=this.id;xr.onreadystatechange=function(){if(xr.readyState!=4){return }xr.onreadystatechange=JsHttpRequest._dummy;req.status=null;try{req.status=xr.status;req.responseText=xr.responseText}catch(e){}if(!req.status){return }try{eval("JsHttpRequest._tmp = function(id) { var d = "+req.responseText+"; d.id = id; JsHttpRequest.dataReady(d); }")}catch(e){return req._error("js_invalid",req.responseText)}JsHttpRequest._tmp(id);JsHttpRequest._tmp=null};xr.open(this.method,this.url,true,this.username,this.password);if(canSetHeaders){for(var i=0;i<req._reqHeaders.length;i++){xr.setRequestHeader(req._reqHeaders[i][0],req._reqHeaders[i][1])}xr.setRequestHeader("Content-Type","application/octet-stream")}xr.send(this.queryText);this.span=null;this.xr=xr;return null};this.getAllResponseHeaders=function(){return this.xr.getAllResponseHeaders()};this.getResponseHeader=function(label){return this.xr.getResponseHeader(label)};this.abort=function(){this.xr.abort();this.xr=null}}};JsHttpRequest.LOADERS.script={loader:function(A){JsHttpRequest.extend(A._errors,{script_only_get:"Cannot use SCRIPT loader: it supports only GET method",script_no_form:"Cannot use SCRIPT loader: direct form elements using and uploading are not implemented"});this.load=function(){if(this.queryText){this.url+=(this.url.indexOf("?")>=0?"&":"?")+this.queryText}this.url+=(this.url.indexOf("?")>=0?"&":"?")+"JsHttpRequest="+this.id+"-script";this.queryText="";if(!this.method){this.method="GET"}if(this.method!=="GET"){return["script_only_get"]}if(this.queryElem.length){return["script_no_form"]}if(this.url.length>JsHttpRequest.MAX_URL_LEN){return["url_too_long",JsHttpRequest.MAX_URL_LEN]}var D=this,E=document,C=null,B=E.body;if(!window.opera){this.span=C=E.createElement("SCRIPT");var F=function(){C.language="JavaScript";if(C.setAttribute){C.setAttribute("src",D.url)}else{C.src=D.url}B.insertBefore(C,B.lastChild)}}else{this.span=C=E.createElement("SPAN");C.style.display="none";B.insertBefore(C,B.lastChild);C.innerHTML="Workaround for IE.<script><\\/script>";var F=function(){C=C.getElementsByTagName("SCRIPT")[0];C.language="JavaScript";if(C.setAttribute){C.setAttribute("src",D.url)}else{C.src=D.url}}}JsHttpRequest.setTimeout(F,10);return null}}};JsHttpRequest.LOADERS.form={loader:function(A){JsHttpRequest.extend(A._errors,{form_el_not_belong:'Element "%" does not belong to any form!',form_el_belong_diff:'Element "%" belongs to a different form. All elements must belong to the same form!',form_el_inv_enctype:'Attribute "enctype" of the form must be "%" (for IE), "%" given.'});this.load=function(){var E=this;if(!E.method){E.method="POST"}E.url+=(E.url.indexOf("?")>=0?"&":"?")+"JsHttpRequest="+E.id+"-form";if(E.method=="GET"){if(E.queryText){E.url+=(E.url.indexOf("?")>=0?"&":"?")+E.queryText}if(E.url.length>JsHttpRequest.MAX_URL_LEN){return["url_too_long",JsHttpRequest.MAX_URL_LEN]}var D=E.url.split("?",2);E.url=D[0];E.queryText=D[1]||""}var F=null;var B=false;if(E.queryElem.length){if(E.queryElem[0].e.tagName.toUpperCase()=="FORM"){F=E.queryElem[0].e;B=true;E.queryElem=[]}else{F=E.queryElem[0].e.form;for(var I=0;I<E.queryElem.length;I++){var K=E.queryElem[I].e;if(!K.form){return["form_el_not_belong",K.name]}if(K.form!=F){return["form_el_belong_diff",K.name]}}}if(E.method=="POST"){var M="multipart/form-data";var G=(F.attributes.encType&&F.attributes.encType.nodeValue)||(F.attributes.enctype&&F.attributes.enctype.value)||F.enctype;if(G!=M){return["form_el_inv_enctype",M,G]}}}var L=F&&(F.ownerDocument||F.document)||document;var H="jshr_i_"+E.id;var N=E.span=L.createElement("DIV");N.style.position="absolute";N.style.display="none";N.style.visibility="hidden";N.innerHTML=(F?"":"<form"+(E.method=="POST"?' enctype="multipart/form-data" method="post"':"")+"></form>")+'<iframe name="'+H+'" id="'+H+'" style="width:0px; height:0px; overflow:hidden; border:none"></iframe>';if(!F){F=E.span.firstChild}L.body.insertBefore(N,L.body.lastChild);var C=function(U,O){var P=[];var T=U;if(U.mergeAttributes){var T=L.createElement("form");T.mergeAttributes(U,false)}for(var S=0;S<O.length;S++){var R=O[S][0],Q=O[S][1];P[P.length]=[R,T.getAttribute(R)];T.setAttribute(R,Q)}if(U.mergeAttributes){U.mergeAttributes(T,false)}return P};var J=function(){top.JsHttpRequestGlobal=JsHttpRequest;var R=[];if(!B){for(var P=0,U=F.elements.length;P<U;P++){R[P]=F.elements[P].name;F.elements[P].name=""}}var T=E.queryText.split("&");for(var P=T.length-1;P>=0;P--){var S=T[P].split("=",2);var Q=L.createElement("INPUT");Q.type="hidden";Q.name=unescape(S[0]);Q.value=S[1]!=null?unescape(S[1]):"";F.appendChild(Q)}for(var P=0;P<E.queryElem.length;P++){E.queryElem[P].e.name=E.queryElem[P].name}var O=C(F,[["action",E.url],["method",E.method],["onsubmit",null],["target",H]]);F.submit();C(F,O);for(var P=0;P<T.length;P++){F.lastChild.parentNode.removeChild(F.lastChild)}if(!B){for(var P=0,U=F.elements.length;P<U;P++){F.elements[P].name=R[P]}}};JsHttpRequest.setTimeout(J,100);return null}}};if(typeof NL=="undefined"){var NL={}}NL.namespace=function(){var A=arguments,E=null,C,B,D;for(C=0;C<A.length;C=C+1){E=NL;D=A[C].split(".");for(B=(D[0]=="NL")?1:0;B<D.length;B=B+1){E[D[B]]=E[D[B]]||{};E=E[D[B]]}}return E};NL.fe=NL.foreach=function(C,B){for(var A in C){B(A,C[A])}};NL.REDISTR_CALL=function(D,B,C){var A=D(B,C);if(A&&A[0]){return A[1]}else{alert("NL: Error, unable to call function '"+str_func+"' from REDISTR")}return 0};if(typeof NL=="undefined"){alert("NL.Cache: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Cache")}NL.Cache._OBJ_CACHE={};NL.Cache.add=function(B,A){if(B&&A){NL.Cache._OBJ_CACHE[B]=A;return true}return false};NL.Cache.get=function(A){if(A&&NL.Cache._OBJ_CACHE[A]){return NL.Cache._OBJ_CACHE[A]}return null};NL.Cache.remove=function(A){if(A&&NL.Cache._OBJ_CACHE[A]){delete NL.Cache._OBJ_CACHE[A];return true}return false};if(typeof NL=="undefined"){alert("NL.Debug: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Debug")}NL.Debug._DATA={BUFFER:[]};NL.Debug.dump=function(D,A){var H="";if(!A){A=0}var G="";for(var C=0;C<A+1;C++){G+="    "}if(typeof (D)=="object"){for(var E in D){var F=D[E];if(typeof (F)=="object"){H+=G+"'"+E+"' => ";var B="";if(!B){H+="[object]\\n"}else{H+="\\n"+B}}else{H+=G+"'"+E+"' => \\""+F+'"\\n'}}}else{H="=>"+D+"<= ("+typeof (D)+")"}return"DUMP:\\n---\\n"+H+"---"};NL.Debug.dump_alert=function(A){alert(NL.Debug.dump(A))};NL.Debug.buffer_reset=function(A){NL.Debug._DATA.BUFFER=[]};NL.Debug.buffer_add=function(A){NL.Debug._DATA.BUFFER.push(A)};NL.Debug.buffer_get=function(){var A="";for(var B in NL.Debug._DATA.BUFFER){if(A!=""){A+="\\n"}A+=NL.Debug._DATA.BUFFER[B]}return A};NL.Debug.buffer_alert=function(){alert(NL.Debug.buffer_get())};if(typeof NL=="undefined"){alert("NL.String: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("String")}NL.String.RE_REPLACE=function(D,C){if(D){var A=C.length;if(A>0&&(A%2==0)){for(var B=0;B<A;B+=2){D=D.replace(C[B],C[B+1])}}return D}return""};NL.String.trim=function(A){A=""+A;A=A.replace(/^[\\s\\n\\r]+/,"");A=A.replace(/[\\s\\n\\r]+\$/,"");return A};NL.String.toLINE_escape=function(A){A=""+A;A=A.replace(/\\\\/g,"\\\\\\\\");A=A.replace(/"/g,'\\\\"');A=A.replace(/\\n/g,"\\\\n");A=A.replace(/\\r/g,"\\\\r");A=A.replace(/\\t/g,"\\\\t");return A};NL.String.toHTML=function(B,A){B=""+B;B=B.replace(/&/g,"&amp;");B=B.replace(/ /g,"&nbsp;");B=B.replace(/\\t/g,"&nbsp;&nbsp;&nbsp;");B=B.replace(/</g,"&lt;");B=B.replace(/>/g,"&gt;");if(A){B=B.replace(/"/g,"&quot;")}return B};NL.String.fromHTML=function(A){A=""+A;A=A.replace(/[\\xA0]/g," ");A=A.replace(/&nbsp;/g," ");A=A.replace(/&lt;/g,"<");A=A.replace(/&gt;/g,">");A=A.replace(/&quot;/g,"'");A=A.replace(/&amp;/g,"&");return A};NL.String.toLINE=function(A){A=""+A;return A.replace(/[\\n\\r]+/," ")};NL.String.get_str_right=function(C,E,D){var A=E;if(C.length>A){var B=0;if(D&&E>=3){A=E-3;B=1}C=(B?"...":"")+C.substr(C.length-A)}return C};NL.String.get_str_right_dottes=function(A,B){return NL.String.get_str_right(A,B,1)};NL.String.get_str_of_bytes=function(H){var A=["Kb","MB","GB"];var I=H;var F=-1;for(var E=0;E<A.length;E++){var C=I/1024;if(C>=1){I=C;F=E}else{break}}var B=Math.floor(I);var G=Math.floor((I-B)*100);var D=""+B+((G>0)?("."+G):"");return D+" "+(F>=0?A[F]:"bytes")};if(typeof NL=="undefined"){alert("NL.Browser: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Browser.Detect")}NL.Browser.Detect.isIE7=NL.Browser.Detect.isIE=NL.Browser.Detect.isFF=NL.Browser.Detect.isFF3=NL.Browser.Detect.isOPERA=NL.Browser.Detect.isSAFARI=NL.Browser.Detect.isSAFARI_MOB=false;NL.Browser.Detect.UA=function(){return(navigator.userAgent)?navigator.userAgent.toLowerCase():""}();NL.Browser.Detect._init=function(){var A=(navigator.vendor)?navigator.vendor.toLowerCase():"";if(window.opera){NL.Browser.Detect.isOPERA=true}else{if(A.indexOf("apple")!=-1){NL.Browser.Detect.isSAFARI=true;if(NL.Browser.Detect.UA.match(/iphone.*mobile.*safari/)){NL.Browser.Detect.isSAFARI_MOB=true}}else{if(A!="kde"&&document.all&&NL.Browser.Detect.UA.indexOf("msie")!=-1){NL.Browser.Detect.isIE=true;if(window.XMLHttpRequest){NL.Browser.Detect.isIE7=true}}else{if(NL.Browser.Detect.UA.indexOf("firefox")!=-1||NL.Browser.Detect.UA.indexOf("iceweasel")!=-1){NL.Browser.Detect.isFF=true;if(NL.Browser.Detect.UA.match(/(firefox|iceweasel)\\/3/)){NL.Browser.Detect.isFF3=true}}}}}}();if(typeof NL=="undefined"){alert("NL.UI: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("UI")}NL.UI.object_remove=function(A){if(A){var B=xGetElementById(A);if(B&&B.parentNode){B.parentNode.removeChild(B)}}};NL.UI.object_make_unselectable=function(A){if(A){var B=xGetElementById(A);if(B){if(NL.Browser.Detect.isFF){if(B.style){B.style.MozUserSelect="none"}}else{if(NL.Browser.Detect.isSAFARI){if(B.style){B.style.KhtmlUserSelect="none"}}else{if(NL.Browser.Detect.isIE||NL.Browser.Detect.isOPERA){A.unselectable="on"}}}}}};NL.UI.object_event_SCROLL=function(B,C){if(B&&C){var A=xGetElementById(B);if(A){if(NL.Browser.Detect.isIE){A.attachEvent("onmousewheel",C)}else{if(NL.Browser.Detect.isFF){A.addEventListener("DOMMouseScroll",C,false)}else{A.onmousewheel=C}}}}};NL.UI.object_event_SCROLL_get_delta=function(A,C){var B=0;if(!A){A=window.event}if(A.wheelDelta){B=A.wheelDelta/120;if(!C){A.returnValue=false}}else{if(A.detail){B=-A.detail/3;if(!C){A.preventDefault()}}}return B};NL.UI.switcher_register=function(A,C,E){var B=xGetElementById(C);if(B){if(E){B.checked=1}xAddEventListener(C,"click",function(){NL.UI.switcher_pressed(A,C);return true},false);var D=xGetElementById(C+"-LABEL");if(D){NL.UI.object_make_unselectable(D)}NL.UI.switcher_pressed(A,C)}};NL.UI.switcher_pressed=function(B,E){var D=B+"-pressed";var A=B+"-unpressed";var C=xGetElementById(E);if(C){var F=xGetElementById(E+"-AREA");if(F){if(C.checked){if(xHasClass(F,A)){xRemoveClass(F,A);xAddClass(F,D)}}else{if(xHasClass(F,D)){xRemoveClass(F,D);xAddClass(F,A)}}C.blur()}}};NL.UI.div_button_register=function(C,E,B,A){var D=xGetElementById(E);if(D){NL.UI.object_make_unselectable(D);xAddEventListener(E,"mousedown",function(){NL.UI.div_button_pressed(C,E,1,B,A)},false);xAddEventListener(E,"mouseup",function(){NL.UI.div_button_pressed(C,E,0,B,A)},false);xAddEventListener(E,"mouseout",function(){NL.UI.div_button_pressed(C,E,0,B,A)},false);if(NL.Browser.Detect.isIE){xAddEventListener(E,"dblclick",function(){NL.UI.div_button_pressed(C,E,2,B,A)},false)}}};NL.UI.div_button_pressed=function(D,G,C,B,A){var F=xGetElementById(G);if(F){var E=D+"-pressed";if(C==1){if(!xHasClass(F,E)){xAddClass(F,E);return true}}else{if(C==2){B(A);return true}else{if(xHasClass(F,E)){xRemoveClass(F,E);B(A);return true}}}}return false};NL.UI.div_button_pressed_OLD=function(D,H,C,B,A){var E=D+"-unpressed";var G=D+"-pressed";var F=xGetElementById(H);if(!F){return false}if(C==1){if(xHasClass(F,E)){xRemoveClass(F,E);xAddClass(F,G)}}else{if(C==2){B(A)}else{if(xHasClass(F,G)){xRemoveClass(F,G);xAddClass(F,E);B(A)}}}return false};NL.UI.input_allow_tab_OBJ_FOCUS=null;NL.UI.input_allow_tab_REMOVE_TAB=function(A){return A.replace(/(^|\\n)\\t/g,"\$1")};NL.UI.input_allow_tab_ADD_TAB=function(A){return A.replace(/(^|\\n)([\\t\\S])/g,"\$1\\t\$2")};NL.UI.input_allow_tab=function(A){if(A){var B=xGetElementById(A);if(B&&!B.is_TAB_ALLOWED){B.is_TAB_ALLOWED=true;B.is_TAB_PRESSED=false;if(NL.Browser.Detect.isIE){xAddEventListener(B,"keydown",function(H){if(window.event.keyCode==9){var G=document.selection.createRange();if(G.text.length>0){if(window.event.shiftKey){var E=NL.UI.input_allow_tab_REMOVE_TAB(G.text);G.text=E;if(E.length<=0){if(B.createTextRange){var C=0;var F=document.selection.createRange().duplicate();F.moveEnd("character",B.value.length);if(F.text==""){C=B.value.length}else{C=B.value.lastIndexOf(F.text)}if(B.createTextRange){var D=B.createTextRange();D.move("character",C);D.select()}}}}else{G.text=NL.UI.input_allow_tab_ADD_TAB(G.text)}}else{G.text="\\t"}return false}},false)}else{xAddEventListener(B,"keypress",function(H){if(H.keyCode==9){this.is_TAB_PRESSED=true;var C=this.scrollTop;var D=this.selectionStart;var F=this.selectionEnd;var I=this.value.substring(0,D);var J=this.value.substring(D,F);var G=this.value.substring(F,this.value.length);var K=false;if(J.length>0){K=true;if(H.shiftKey){J=NL.UI.input_allow_tab_REMOVE_TAB(J)}else{J=NL.UI.input_allow_tab_ADD_TAB(J)}}else{J="\\t"}this.value=I+J+G;this.focus();if(K){if(NL.Browser.Detect.isOPERA&&J.length<=0&&this.createTextRange){var E=this.createTextRange();E.move("character",D);E.select()}else{this.selectionStart=D;this.selectionEnd=D+J.length}}else{D++;this.selectionStart=D;this.selectionEnd=D}this.scrollTop=C;if(H.cancelable){H.preventDefault();H.stopPropagation()}}},false);if(!NL.Browser.Detect.isFF){xAddEventListener(B,"blur",function(C){if(this.is_TAB_PRESSED){this.is_TAB_PRESSED=false;NL.UI.inpu_allow_tab_OBJ_FOCUS=B;setTimeout("NL.UI.inpu_allow_tab_OBJ_FOCUS.focus()",1)}},false)}}}}};if(typeof NL=="undefined"){alert("NL.Form: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Form")}NL.Form.alert_error=function(A){var B="Form completion checking ERROR: '"+A+"'";alert(B)};NL.Form.FUNC_CHECK_email=function(A){if(A&&A!=""){if(A.indexOf("@")>0&&A.indexOf(".")>=0){return 1}}return 0};NL.Form.check_fields=function(H,C){var G={};for(var A in H){var B=xGetElementById(A);if(!B){NL.Form.alert_error('Unable to find "'+A+'" object');return 0}else{var F="";if(H[A]["type"]&&H[A]["type"]=="checkbox"){F="CHECKBOX"}else{if(B.value&&B.value!=""){F="MAIN"}}if(F=="CHECKBOX"){if(C){if(B.checked){var I=H[A]["name_at_hash"]?H[A]["name_at_hash"]:A;G[I]=1}}}else{if(F!=""){if(H[A]["func_CHECK"]){if(!H[A]["func_CHECK"](B.value)){alert('"'+H[A]["name"]+'" is incorrect, please fix it...');if(!H[A]["func_BEFORE_FOCUS"]||H[A]["func_BEFORE_FOCUS"]()){B.focus()}return 0}}if(H[A]["confirm"]){var D=A+"_c";var J=xGetElementById(D);if(J){if(J.value&&J.value!=""){if(J.value!=B.value){alert('"'+H[A]["name"]+'" and "Confirm '+H[A]["name"].toLowerCase()+'" are not the same, please fill that fields again...');if(!H[A]["func_BEFORE_FOCUS"]||H[A]["func_BEFORE_FOCUS"]()){B.focus()}return 0}}else{alert('"Confirm '+H[A]["name"].toLowerCase()+"\\" can't be empty, please fill that field...");if(!H[A]["func_BEFORE_FOCUS"]||H[A]["func_BEFORE_FOCUS"]()){J.focus()}return 0}}else{NL.Form.alert_error('Unable to find "'+D+'" object');return 0}}if(H[A]["func_HOOK"]){H[A]["func_HOOK"](B.value)}if(C){var I=H[A]["name_at_hash"]?H[A]["name_at_hash"]:A;if(H[A]["func_ENCODE"]){var E=H[A]["func_ENCODE"](B.value);if(E[0]==1){if(E[1]){G[I]=E[1]}}else{if(E[0]==-1){if(!H[A]["func_BEFORE_FOCUS"]||H[A]["func_BEFORE_FOCUS"]()){B.focus()}}return 0}}else{G[I]=B.value}}}else{if(H[A]["needed"]){alert('"'+H[A]["name"]+"\\" can't be empty, please fill that field...");if(!H[A]["func_BEFORE_FOCUS"]||H[A]["func_BEFORE_FOCUS"]()){B.focus()}return 0}}}}}if(C){return G}else{return 1}};NL.Form._allow_TAB_KEY_PRESS_HOOK=function(H){var D=null;if(window.event){D=window.event}else{if(parent&&parent.event){D=parent.event}else{if(H){D=H}}}if(D){if(this&&D.keyCode==9){var E=0;if(this.createTextRange){var A=document.selection.createRange().duplicate();A.moveEnd("character",this.value.length);if(A.text==""){E=this.value.length}else{E=this.value.lastIndexOf(A.text)}}else{E=this.selectionStart||0}var F="\\t";if(E>=0){if(E==0){this.value=F+this.value}else{if(E>=this.value.length){E=this.value.length;this.value=this.value+F}else{var B=this.value.substr(0,E);var I=this.value.substr(E);this.value=B+F+I}}}var C=E+F.length;if(this.createTextRange){var G=this.createTextRange();G.move("character",C);G.select()}else{if(this.selectionStart){this.focus();this.setSelectionRange(C,C);if(C==0){this.focus()}}else{this.focus()}}return false}}return true};NL.Form.allow_TAB=function(B){if(B){var A=xGetElementById(B);if(A){if(NL.Browser.Detect.isIE){A.onkeydown=NL.Form._allow_TAB_KEY_PRESS_HOOK}else{A.onkeypress=NL.Form._allow_TAB_KEY_PRESS_HOOK}}}};NL.Form.value_get=function(B){if(B){var A=xGetElementById(B);if(A&&A.value){return A.value}}return""};NL.Form.value_set=function(D,C,A){if(D&&C){var B=xGetElementById(D);if(B){B.value=C;if(A){B.focus()}return 1}}return 0};if(typeof NL=="undefined"){alert("NL.Crypt: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Crypt","Crypt.REDISTR")}NL.Crypt.base64_encode=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.Base64,"Base64.encode",arguments)};NL.Crypt.base64_decode=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.Base64,"Base64.decode",arguments)};NL.Crypt.sha1_vm_test=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1,"sha1_vm_test",arguments)};NL.Crypt.sha1=NL.Crypt.sha1_hex=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1,"hex_sha1",arguments)};NL.Crypt.sha1_b64=function(){return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1,"b64_sha1",arguments)};NL.Crypt.get_random_text=function(){var B=(navigator.userAgent)?navigator.userAgent:"";B+=("mr1:"+Math.random()||0)+("mr2:"+Math.random()||0)+("mr3:"+Math.random()||0);B+="sw:"+screen.width||0;B+="sh:"+screen.height||0;B+="cw:"+NL.REDISTR_call(NL.Crypt.REDISTR.X,"xClientHeight",arguments)||0;B+="ch:"+NL.REDISTR_call(NL.Crypt.REDISTR.X,"xClientWidth",arguments)||0;var A=new Date();B+="t_ms:"+A.getTime()||0;B+="tz_ms:"+A.getTimezoneOffset()||0;return B};NL.Crypt.get_random_sha1=NL.Crypt.get_random_sha1_hex=function(){return NL.Crypt.sha1_hex(NL.Crypt.get_random_text())};NL.Crypt.REDISTR.X=function(){function xDef(){for(var i=0;i<arguments.length;++i){if(typeof (arguments[i])=="undefined"){return false}}return true}function xClientHeight(){var v=0,d=document,w=window;if((!d.compatMode||d.compatMode=="CSS1Compat")&&!w.opera&&d.documentElement&&d.documentElement.clientHeight){v=d.documentElement.clientHeight}else{if(d.body&&d.body.clientHeight){v=d.body.clientHeight}else{if(xDef(w.innerWidth,w.innerHeight,d.width)){v=w.innerHeight;if(d.width>w.innerWidth){v-=16}}}}return v}function xClientWidth(){var v=0,d=document,w=window;if((!d.compatMode||d.compatMode=="CSS1Compat")&&!w.opera&&d.documentElement&&d.documentElement.clientWidth){v=d.documentElement.clientWidth}else{if(d.body&&d.body.clientWidth){v=d.body.clientWidth}else{if(xDef(w.innerWidth,w.innerHeight,d.height)){v=w.innerWidth;if(d.height>w.innerHeight){v-=16}}}}return v}if(arguments.length==2&&arguments[0]!=""&&arguments[1]){var NL_TMP_FUNC=null;try{eval("NL_TMP_FUNC="+arguments[0]+";")}catch(e){NL_TMP_FUNC=null}if(NL_TMP_FUNC){return[1,NL_TMP_FUNC.apply(this,arguments[1])]}}return[0,null]};NL.Crypt.REDISTR.SHA1=function(){var hexcase=0;var b64pad="";function hex_sha1(s){return rstr2hex(rstr_sha1(str2rstr_utf8(s)))}function b64_sha1(s){return rstr2b64(rstr_sha1(str2rstr_utf8(s)))}function any_sha1(s,e){return rstr2any(rstr_sha1(str2rstr_utf8(s)),e)}function hex_hmac_sha1(k,d){return rstr2hex(rstr_hmac_sha1(str2rstr_utf8(k),str2rstr_utf8(d)))}function b64_hmac_sha1(k,d){return rstr2b64(rstr_hmac_sha1(str2rstr_utf8(k),str2rstr_utf8(d)))}function any_hmac_sha1(k,d,e){return rstr2any(rstr_hmac_sha1(str2rstr_utf8(k),str2rstr_utf8(d)),e)}function sha1_vm_test(){return hex_sha1("abc")=="a9993e364706816aba3e25717850c26c9cd0d89d"}function rstr_sha1(s){return binb2rstr(binb_sha1(rstr2binb(s),s.length*8))}function rstr_hmac_sha1(key,data){var bkey=rstr2binb(key);if(bkey.length>16){bkey=binb_sha1(bkey,key.length*8)}var ipad=Array(16),opad=Array(16);for(var i=0;i<16;i++){ipad[i]=bkey[i]^909522486;opad[i]=bkey[i]^1549556828}var hash=binb_sha1(ipad.concat(rstr2binb(data)),512+data.length*8);return binb2rstr(binb_sha1(opad.concat(hash),512+160))}function rstr2hex(input){var hex_tab=hexcase?"0123456789ABCDEF":"0123456789abcdef";var output="";var x;for(var i=0;i<input.length;i++){x=input.charCodeAt(i);output+=hex_tab.charAt((x>>>4)&15)+hex_tab.charAt(x&15)}return output}function rstr2b64(input){var tab="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";var output="";var len=input.length;for(var i=0;i<len;i+=3){var triplet=(input.charCodeAt(i)<<16)|(i+1<len?input.charCodeAt(i+1)<<8:0)|(i+2<len?input.charCodeAt(i+2):0);for(var j=0;j<4;j++){if(i*8+j*6>input.length*8){output+=b64pad}else{output+=tab.charAt((triplet>>>6*(3-j))&63)}}}return output}function rstr2any(input,encoding){var divisor=encoding.length;var remainders=Array();var i,q,x,quotient;var dividend=Array(Math.ceil(input.length/2));for(i=0;i<dividend.length;i++){dividend[i]=(input.charCodeAt(i*2)<<8)|input.charCodeAt(i*2+1)}while(dividend.length>0){quotient=Array();x=0;for(i=0;i<dividend.length;i++){x=(x<<16)+dividend[i];q=Math.floor(x/divisor);x-=q*divisor;if(quotient.length>0||q>0){quotient[quotient.length]=q}}remainders[remainders.length]=x;dividend=quotient}var output="";for(i=remainders.length-1;i>=0;i--){output+=encoding.charAt(remainders[i])}var full_length=Math.ceil(input.length*8/(Math.log(encoding.length)/Math.log(2)));for(i=output.length;i<full_length;i++){output=encoding[0]+output}return output}function str2rstr_utf8(input){var output="";var i=-1;var x,y;while(++i<input.length){x=input.charCodeAt(i);y=i+1<input.length?input.charCodeAt(i+1):0;if(55296<=x&&x<=56319&&56320<=y&&y<=57343){x=65536+((x&1023)<<10)+(y&1023);i++}if(x<=127){output+=String.fromCharCode(x)}else{if(x<=2047){output+=String.fromCharCode(192|((x>>>6)&31),128|(x&63))}else{if(x<=65535){output+=String.fromCharCode(224|((x>>>12)&15),128|((x>>>6)&63),128|(x&63))}else{if(x<=2097151){output+=String.fromCharCode(240|((x>>>18)&7),128|((x>>>12)&63),128|((x>>>6)&63),128|(x&63))}}}}}return output}function str2rstr_utf16le(input){var output="";for(var i=0;i<input.length;i++){output+=String.fromCharCode(input.charCodeAt(i)&255,(input.charCodeAt(i)>>>8)&255)}return output}function str2rstr_utf16be(input){var output="";for(var i=0;i<input.length;i++){output+=String.fromCharCode((input.charCodeAt(i)>>>8)&255,input.charCodeAt(i)&255)}return output}function rstr2binb(input){var output=Array(input.length>>2);for(var i=0;i<output.length;i++){output[i]=0}for(var i=0;i<input.length*8;i+=8){output[i>>5]|=(input.charCodeAt(i/8)&255)<<(24-i%32)}return output}function binb2rstr(input){var output="";for(var i=0;i<input.length*32;i+=8){output+=String.fromCharCode((input[i>>5]>>>(24-i%32))&255)}return output}function binb_sha1(x,len){x[len>>5]|=128<<(24-len%32);x[((len+64>>9)<<4)+15]=len;var w=Array(80);var a=1732584193;var b=-271733879;var c=-1732584194;var d=271733878;var e=-1009589776;for(var i=0;i<x.length;i+=16){var olda=a;var oldb=b;var oldc=c;var oldd=d;var olde=e;for(var j=0;j<80;j++){if(j<16){w[j]=x[i+j]}else{w[j]=bit_rol(w[j-3]^w[j-8]^w[j-14]^w[j-16],1)}var t=safe_add(safe_add(bit_rol(a,5),sha1_ft(j,b,c,d)),safe_add(safe_add(e,w[j]),sha1_kt(j)));e=d;d=c;c=bit_rol(b,30);b=a;a=t}a=safe_add(a,olda);b=safe_add(b,oldb);c=safe_add(c,oldc);d=safe_add(d,oldd);e=safe_add(e,olde)}return Array(a,b,c,d,e)}function sha1_ft(t,b,c,d){if(t<20){return(b&c)|((~b)&d)}if(t<40){return b^c^d}if(t<60){return(b&c)|(b&d)|(c&d)}return b^c^d}function sha1_kt(t){return(t<20)?1518500249:(t<40)?1859775393:(t<60)?-1894007588:-899497514}function safe_add(x,y){var lsw=(x&65535)+(y&65535);var msw=(x>>16)+(y>>16)+(lsw>>16);return(msw<<16)|(lsw&65535)}function bit_rol(num,cnt){return(num<<cnt)|(num>>>(32-cnt))}if(arguments.length==2&&arguments[0]!=""&&arguments[1]){var NL_TMP_FUNC=null;try{eval("NL_TMP_FUNC="+arguments[0]+";")}catch(e){NL_TMP_FUNC=null}if(NL_TMP_FUNC){return[1,NL_TMP_FUNC.apply(this,arguments[1])]}}return[0,null]};NL.Crypt.REDISTR.Base64=function(){var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(input){var output="";var chr1,chr2,chr3,enc1,enc2,enc3,enc4;var i=0;input=Base64._utf8_encode(input);while(i<input.length){chr1=input.charCodeAt(i++);chr2=input.charCodeAt(i++);chr3=input.charCodeAt(i++);enc1=chr1>>2;enc2=((chr1&3)<<4)|(chr2>>4);enc3=((chr2&15)<<2)|(chr3>>6);enc4=chr3&63;if(isNaN(chr2)){enc3=enc4=64}else{if(isNaN(chr3)){enc4=64}}output=output+Base64._keyStr.charAt(enc1)+Base64._keyStr.charAt(enc2)+Base64._keyStr.charAt(enc3)+Base64._keyStr.charAt(enc4)}return output},decode:function(input){var output="";var chr1,chr2,chr3;var enc1,enc2,enc3,enc4;var i=0;input=input.replace(/[^A-Za-z0-9\\+\\/\\=]/g,"");while(i<input.length){enc1=Base64._keyStr.indexOf(input.charAt(i++));enc2=Base64._keyStr.indexOf(input.charAt(i++));enc3=Base64._keyStr.indexOf(input.charAt(i++));enc4=Base64._keyStr.indexOf(input.charAt(i++));chr1=(enc1<<2)|(enc2>>4);chr2=((enc2&15)<<4)|(enc3>>2);chr3=((enc3&3)<<6)|enc4;output=output+String.fromCharCode(chr1);if(enc3!=64){output=output+String.fromCharCode(chr2)}if(enc4!=64){output=output+String.fromCharCode(chr3)}}output=Base64._utf8_decode(output);return output},_utf8_encode:function(string){string=string.replace(/\\r\\n/g,"\\n");var utftext="";for(var n=0;n<string.length;n++){var c=string.charCodeAt(n);if(c<128){utftext+=String.fromCharCode(c)}else{if((c>127)&&(c<2048)){utftext+=String.fromCharCode((c>>6)|192);utftext+=String.fromCharCode((c&63)|128)}else{utftext+=String.fromCharCode((c>>12)|224);utftext+=String.fromCharCode(((c>>6)&63)|128);utftext+=String.fromCharCode((c&63)|128)}}}return utftext},_utf8_decode:function(utftext){var string="";var i=0;var c=c1=c2=0;while(i<utftext.length){c=utftext.charCodeAt(i);if(c<128){string+=String.fromCharCode(c);i++}else{if((c>191)&&(c<224)){c2=utftext.charCodeAt(i+1);string+=String.fromCharCode(((c&31)<<6)|(c2&63));i+=2}else{c2=utftext.charCodeAt(i+1);c3=utftext.charCodeAt(i+2);string+=String.fromCharCode(((c&15)<<12)|((c2&63)<<6)|(c3&63));i+=3}}}return string}};if(arguments.length==2&&arguments[0]!=""&&arguments[1]){var NL_TMP_FUNC=null;try{eval("NL_TMP_FUNC="+arguments[0]+";")}catch(e){NL_TMP_FUNC=null}if(NL_TMP_FUNC){return[1,NL_TMP_FUNC.apply(this,arguments[1])]}}return[0,null]};if(typeof NL=="undefined"){var NL={Timer:{}}}else{NL.namespace("Timer")}NL.Timer._OBJ_TIMER={LOCKS:{}};NL.Timer.get_current_time=function(){return(new Date()).getTime()};NL.Timer.get_str_time=function(E,D){var C=0;if(D){C=E}else{C=Math.ceil(E/1000)}var B=Math.floor(C/3600);C-=B*3600;var A=Math.floor(C/60);C-=A*60;if(String(B).length<2){B=String("0"+B)}if(String(A).length<2){A=String("0"+A)}if(String(C).length<2){C=String("0"+C)}return B+":"+A+":"+C};NL.Timer._get_item_id=function(C,D,A){if(typeof A=="undefined"){A=""}if(typeof C!="undefined"&&typeof D!="undefined"&&C.length>0){for(var B in C){if(A!=""){if(typeof C[B][A]!="undefined"&&C[B][A]==D){return B}}else{if(C[B]==D){return B}}}}return -1};NL.Timer.timer_add=function(D,B,A){if(typeof A=="undefined"){A=null}if(typeof D!="undefined"&&typeof B!="undefined"&&D>0&&NL.Timer._OBJ_TIMER){if(NL.Timer._OBJ_TIMER[D]){if(NL.Timer._OBJ_TIMER[D]["functions"]){var C=NL.Timer._get_item_id(NL.Timer._OBJ_TIMER[D]["functions"],B,"function");if(C>=0){if(typeof NL.Timer._OBJ_TIMER[D]["functions"][C]["DATA"]!="undefined"){if(NL.Timer._get_item_id(NL.Timer._OBJ_TIMER[D]["functions"][C]["DATA"],A,"stash")<0){NL.Timer._OBJ_TIMER[D]["functions"][C]["DATA"].push({time:0,stash:A})}}else{NL.Timer._OBJ_TIMER[D]["functions"][C]["DATA"]=[{time:0,stash:A}]}}else{NL.Timer._OBJ_TIMER[D]["functions"].push({"function":B,DATA:[{time:0,stash:A}]})}}else{NL.Timer._OBJ_TIMER[D]["functions"]=[{"function":B,DATA:[{time:0,stash:A}]}]}}else{NL.Timer._OBJ_TIMER[D]={functions:[{"function":B,DATA:[{time:0,stash:A}]}]}}return 1}return 0};NL.Timer.timer_add_SECOND=function(B,A){return NL.Timer.timer_add(1000,B,A)};NL.Timer.timer_add_and_on=function(C,B,A){if(NL.Timer.timer_add(C,B,A)){return NL.Timer.timer_on(C)}return 0};NL.Timer.timer_add_exec_and_on=function(D,C,B,A){if(A&&A.SLEEP_MS){NL.Timer.sleep(A.SLEEP_MS)}C(B,0);return NL.Timer.timer_add_and_on(D,C,B)};NL.Timer.sleep=function(A){var C=new Date();var B=C.getTime()+A;while(true){C=new Date();if(C.getTime()>B){return }}};NL.Timer.timer_add_and_on_SECOND=function(B,A){return NL.Timer.timer_add_and_on(1000,B,A)};NL.Timer.timer_is_on=function(A){if(typeof A!="undefined"&&A>0&&NL.Timer._OBJ_TIMER){if(NL.Timer._OBJ_TIMER[A]&&NL.Timer._OBJ_TIMER[A]["TIMER_OBJECT"]){return 1}}return 0};NL.Timer.timer_on=function(A){if(typeof A!="undefined"&&A>0&&NL.Timer._OBJ_TIMER){if(NL.Timer._OBJ_TIMER[A]){if(!NL.Timer._OBJ_TIMER[A]["TIMER_OBJECT"]){if(NL.Timer._OBJ_TIMER[A]["functions"]&&NL.Timer._OBJ_TIMER[A]["functions"].length>0){NL.Timer._OBJ_TIMER[A]["TIMER_OBJECT"]=setInterval("NL.Timer._timer_update("+A+")",A)}}return 1}}return 0};NL.Timer.timer_off=function(A){if(typeof A!="undefined"&&A>0&&NL.Timer._OBJ_TIMER){if(NL.Timer._OBJ_TIMER[A]){if(NL.Timer._OBJ_TIMER[A]["TIMER_OBJECT"]){clearInterval(NL.Timer._OBJ_TIMER[A]["TIMER_OBJECT"]);delete NL.Timer._OBJ_TIMER[A]["TIMER_OBJECT"]}return 1}}return 0};NL.Timer.timer_remove=function(F,D,B){var A="STASH";if(typeof B=="undefined"){A="FUNCTION"}if(typeof D=="undefined"){A="INTERVAL"}if(typeof F!="undefined"&&F>0&&NL.Timer._OBJ_TIMER){if(NL.Timer._OBJ_TIMER[F]){if(A=="INTERVAL"){NL.Timer.timer_off(F);delete NL.Timer._OBJ_TIMER[F];return 1}else{if(NL.Timer._OBJ_TIMER[F]["functions"]&&NL.Timer._OBJ_TIMER[F]["functions"].length>0){for(var C in NL.Timer._OBJ_TIMER[F]["functions"]){if(NL.Timer._OBJ_TIMER[F]["functions"][C]["function"]==D){if(A=="FUNCTION"){NL.Timer.timer_off(F);NL.Timer._OBJ_TIMER[F]["functions"].splice(C,1);if(NL.Timer._OBJ_TIMER[F]["functions"].length<=0){delete NL.Timer._OBJ_TIMER[F]}else{NL.Timer.timer_on(F)}return 1}else{if(A=="STASH"){var E=NL.Timer._get_item_id(NL.Timer._OBJ_TIMER[F]["functions"][C]["DATA"],B,"stash");if(E>=0){NL.Timer.timer_off(F);NL.Timer._OBJ_TIMER[F]["functions"][C]["DATA"].splice(E,1);if(NL.Timer._OBJ_TIMER[F]["functions"][C]["DATA"].length<=0){delete NL.Timer._OBJ_TIMER[F]["functions"][C];if(NL.Timer._OBJ_TIMER[F]["functions"].length<=0){delete NL.Timer._OBJ_TIMER[F]}else{NL.Timer.timer_on(F)}}else{NL.Timer.timer_on(F)}return 1}}}break}}}}}}return 0};NL.Timer._is_browser_FF=function(){return(navigator.userAgent&&(navigator.userAgent.toLowerCase()).indexOf("firefox")!=-1)?true:false}();NL.Timer._timer_update=function(C){if(NL.Timer._is_browser_FF){NL.Timer.timer_off(C)}var A=0;var G=[];var F=[];if(typeof C!="undefined"&&C>0&&NL.Timer._OBJ_TIMER&&NL.Timer._OBJ_TIMER[C]){if(NL.Timer._OBJ_TIMER[C]["functions"]&&NL.Timer._OBJ_TIMER[C]["functions"].length>0){for(var D in NL.Timer._OBJ_TIMER[C]["functions"]){if(NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"]&&NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"].length>0){for(var I in NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"]){NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"][I].time+=C;if(!NL.Timer._OBJ_TIMER[C]["functions"][D]["function"](NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"][I].stash,NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"][I].time)){F.push(I)}}if(F.length>0){if(NL.Timer.timer_is_on(C)){NL.Timer.timer_off(C)}var E=0;for(var B in F){NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"].splice(F[B]-E,1);E++}if(NL.Timer._OBJ_TIMER[C]["functions"][D]["DATA"].length<=0){G.push(D)}}}else{G.push(D)}}if(G.length>0){if(NL.Timer.timer_is_on(C)){NL.Timer.timer_off(C)}var E=0;for(var H in G){NL.Timer._OBJ_TIMER[C]["functions"].splice(G[H]-E,1);E++}if(NL.Timer._OBJ_TIMER[C]["functions"].length<=0){A=1}}}else{A=1}if(A){if(NL.Timer.timer_is_on(C)){NL.Timer.timer_off(C)}delete NL.Timer._OBJ_TIMER[C];return }}if(!NL.Timer.timer_is_on(C)){NL.Timer.timer_on(C)}};if(typeof NL=="undefined"){alert("NL.AJAX: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("AJAX")}NL.AJAX._DATA={ERROR_HANDLER:null};NL.AJAX._JsHttpRequest_ERROR_THROW=function(A,B){if(NL.AJAX._DATA.ERROR_HANDLER){NL.AJAX._DATA.ERROR_HANDLER(typeof A!="undefined"?A:"",typeof B!="undefined"?B:null)}};NL.AJAX.set_ERROR_HANDLER=function(A){if(typeof A!="undefined"&&A){NL.AJAX._DATA.ERROR_HANDLER=A}};NL.AJAX._makeURL=function(A,F){var D="";for(var E in F){if(E!=""&&F[E]!=""){if(D!=""){D+="&"}D+=E+"="+F[E]}}if(D!=""){var C=(A.indexOf("?")==-1)?"?":"&";var B=(A.length>0)?A.charAt(A.length-1):"";return A+((B=="?"||B=="&")?D:C+D)}else{return A}};NL.AJAX.query=function(B,E,A,F,C,D){return JsHttpRequest.query(NL.AJAX._makeURL(B,E),A,F,(C)?false:true,typeof D!="undefined"?D:null)};NL.AJAX.upload=function(B,D,A,F,C){var E=new JsHttpRequest();E.onreadystatechange=function(){if(E.readyState==4){F(E.responseJS,E.responseText)}};E.caching=(C)?false:true;E.open("post",NL.AJAX._makeURL(B,D),false);E.send(A);return E};if(typeof NL=="undefined"){alert("NL Upload: Error - object NL is not defiend, maybe 'NL CORE' is not loaded")}else{NL.namespace("Upload")}NL.Upload._makeURL=function(A,F){var D="";for(var E in F){if(E!=""&&F[E]!=""){if(D!=""){D+="&"}D+=E+"="+F[E]}}var C=(A.indexOf("?")==-1)?"?":"&";var B=(A.length>0)?A.charAt(A.length-1):"";return A+((B=="?"||B=="&")?D:C+D)};NL.Upload._func_callback_timer=function(A,C){if(A.func_Timer(A.STASH,C)){if(A.STASH["IS_DONE"]!=1){var B={params:{},callbacks:{status:A.func_Status}};NL.Upload.get_status(A.url_status,B,A.STASH)}else{}}};NL.Upload.upload=function(J,G,H){if(!J||!G||!G.params||!G.files||!G.callbacks||typeof (G.callbacks["uploaded"])=="undefined"||typeof (G.callbacks["timer"])=="undefined"||typeof (G.callbacks["status"])=="undefined"){return 0}var C={};for(var D=0;D<G.files.length;D++){C["file_"+D]=G.files[D]}if(D<=0){return 0}var B=(G.settings&&G.settings["timer_interval"]&&G.settings["timer_interval"]>0)?G.settings["timer_interval"]:1000;var A=NL.Upload._makeURL(J,G.params);var E=NL.Upload._makeURL(A,{NL_Upload_action:"upload"});var I=NL.Upload._makeURL(A,{NL_Upload_action:"get_status"});var F=function(L,K){G.callbacks["uploaded"]((L&&L.STASH)?L.STASH:{},H)};return NL.AJAX.upload(E,{},C,F);return 1};NL.Upload.get_status=function(B,A,D){if(!B||!A||!A.params||!A.callbacks){return 0}var C=NL.Upload._makeURL(B,A.params);var E=function(G,F){A.callbacks["status"]((G.STASH)?G.STASH:{},D)};NL.AJAX.query(C,{},E);return 1};NL.Upload.get_info=function(B,A,D){if(!B||!A||!A.params||!A.callbacks){return 0}var C=NL.Upload._makeURL(B,A.params);var E=function(G,F){A.callbacks["update_list"]((G.STASH)?G.STASH:{},D)};NL.AJAX.query(C,A.params_POST?A.params_POST:{},E);return 1};if(typeof WC=="undefined"){var WC={}}WC.namespace=function(){var A=arguments,E=null,C,B,D;for(C=0;C<A.length;C=C+1){E=WC;D=A[C].split(".");for(B=(D[0]=="WC")?1:0;B<D.length;B=B+1){E[D[B]]=E[D[B]]||{};E=E[D[B]]}}return E};if(typeof WC=="undefined"){alert("WC.Console: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console")}WC.Console.IS_INITIALIZED=0;WC.Console.ID_PROMPT="";WC.Console.ID_PROMPT_PREFIX="";WC.Console.ID_OUTPUT="";WC.Console.OBJ_PROMPT=undefined;WC.Console.OBJ_PROMPT_PREFIX=undefined;WC.Console.OBJ_OUTPUT=undefined;WC.Console.DATA={PROMPT_is_fosuced:0,PROMPT_cursor_position:-1,GLOBAL_is_grab_input:1};WC.Console.additional_JAVASCRIPT=function(){};WC.Console.init_and_start=function(A,B,C){if(A&&B&&WC.Console.init(A,B,C?C:undefined)){return WC.Console.start()}else{return 0}};WC.Console.init=function(A,B,D){var C;if(D){C=xGetElementById(D);if(C){WC.Console.ID_PROMPT_PREFIX=D;WC.Console.OBJ_PROMPT_PREFIX=C}}if(A){C=xGetElementById(A);if(C){WC.Console.ID_PROMPT=A;WC.Console.OBJ_PROMPT=C}}if(B){C=xGetElementById(B);if(C){WC.Console.ID_OUTPUT=B;WC.Console.OBJ_OUTPUT=C}}WC.DOM.REGISTER_insertAdjacentElement();if(WC.Console.OBJ_PROMPT&&B){WC.Console.IS_INITIALIZED=1;NL.AJAX.set_ERROR_HANDLER(WC.Console.Response.AJAX_ERROR);WC.Console.Prompt.init();return 1}else{return 0}};WC.Console.start=function(){if(WC.Console.IS_INITIALIZED){WC.Console.HTML.add_powered_by();WC.Console.HTML.add_welcome(WC.Console.State.FLAG_SHOW_WELCOME,WC.Console.State.FLAG_SHOW_WARNINGS,WC.Console.State.IS_DEMO);WC.Console.Hooks.init();WC.Console.Prompt.activate();WC.Console.additional_JAVASCRIPT();return 1}else{return 0}};WC.Console.ACTION=function(B){if(B=="ENTER"){var A=WC.Console.Prompt.value_get();if(typeof (A)!="undefined"&&A!=""){WC.Console.History.add(A);WC.Console.Prompt.value_set("");WC.Console.Exec.CMD(A)}}else{if(B=="UP"){WC.Console.Prompt.value_set(WC.Console.History.up())}else{if(B=="DOWN"){WC.Console.Prompt.value_set(WC.Console.History.down())}else{if(B=="TAB"){WC.Console.Autocomplete.CMD(WC.Console.Prompt.value_get_left_part())}else{if(B=="CTRL-D"){if(NL.Browser.Detect.isFF){window.open("javascript:window.close();","_self","");window.close()}else{if(NL.Browser.Detect.isIE){window.opener="x"}window.close()}}else{}}}}}};WC.Console.SET_USER=function(B,A){WC.Console.State.set("USER_LOGIN",B?B:"");WC.Console.State.set("USER_PASSWORD_ENCRYPTED",A?A:"")};if(typeof WC=="undefined"){alert("WC.Console.State: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.State")}WC.Console.State.USER_LOGIN="";WC.Console.State.USER_PASSWORD_ENCRYPTED="";WC.Console.State.DIR_CURRENT="";WC.Console.State.FLAG_SHOW_WELCOME=1;WC.Console.State.FLAG_SHOW_WARNINGS=1;WC.Console.State.IS_DEMO=0;WC.Console.State.set=function(A,B){if(typeof (A)!="undefined"&&typeof (B)!="undefined"){if(typeof (WC.Console.State[A])!="undefined"){WC.Console.State[A]=B}}};WC.Console.State.get_JS=function(){return{dir_current:WC.Console.State.DIR_CURRENT}};WC.Console.State.change_dir=function(A){if(typeof A!="undefined"){WC.Console.State.set("DIR_CURRENT",A);WC.Console.Prompt.prefix_value_set_dir(A)}};if(typeof WC=="undefined"){alert("WC.DOM: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("DOM")}WC.DOM.REGISTER_insertAdjacentElement=function(){if(typeof HTMLElement!="undefined"){if(!HTMLElement.prototype.insertAdjacentElement){HTMLElement.prototype.insertAdjacentElement=function(A,B){switch(A){case"beforeBegin":this.parentNode.insertBefore(B,this);break;case"afterBegin":this.insertBefore(B,this.firstChild);break;case"beforeEnd":this.appendChild(B);break;case"afterEnd":if(this.nextSibling){this.parentNode.insertBefore(B,this.nextSibling)}else{this.parentNode.appendChild(B)}break}}}if(!HTMLElement.prototype.insertAdjacentHTML){HTMLElement.prototype.insertAdjacentHTML=function(B,D){var C=this.ownerDocument.createRange();C.setStartBefore(this);var A=C.createContextualFragment(D);this.insertAdjacentElement(B,A)}}if(!HTMLElement.prototype.insertAdjacentText){HTMLElement.prototype.insertAdjacentText=function(B,C){var A=document.createTextNode(C);this.insertAdjacentElement(B,A)}}}};if(typeof WC=="undefined"){alert("WC.Console.Timer: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.Timer")}WC.Console.Timer.ON_TIMER=function(B,A){if(B&&B.id){var C=xGetElementById(B.id);if(C){C.innerHTML=NL.Timer.get_str_time(A);return 1}}return 0};if(typeof WC=="undefined"){alert("WC.Console.HTML: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.HTML")}WC.Console.HTML._DATA={OUTPUT_ELEMENTS_MAX:40,OUTPUT_ELEMENTS_NOW:[],last_id:0};WC.Console.HTML._get_id=function(){WC.Console.HTML._DATA.last_id++;return"wc_id_"+WC.Console.HTML._DATA.last_id};WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT=function(D,B){if(!B){B="block-cmd-result"}var C=xGetElementById(D);var A=null;if(C){var F=10;var E=0;while(E<F){if(C.tagName&&C.tagName.toLowerCase()=="div"){if(xHasClass(C,B)){A=C;break}}if(C.parentNode){C=C.parentNode;E++}else{break}}}return A};WC.Console.HTML.OUTPUT_remove_result=function(B){var A=WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(B);if(!A||(A.wc_mark&&A.wc_mark=="DO_NOT_CLOSE_ALL")){A=xGetElementById(B)}if(A&&A.parentNode){A.parentNode.removeChild(A);WC.Console.Hooks.chech_focused_FIX_GRAB()}};WC.Console.HTML.OUTPUT_remove_below=function(C){var B=WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(C,"block-cmd");if(B&&B.id&&WC.Console.OBJ_OUTPUT){if(WC.Console.OBJ_OUTPUT.hasChildNodes()){var D=WC.Console.OBJ_OUTPUT.childNodes;for(var A=D.length-1;A>=0;A--){if(D[A].id&&D[A].id==B.id){break}else{WC.Console.OBJ_OUTPUT.removeChild(D[A]);WC.Console.Hooks.chech_focused_FIX_GRAB()}}}}};WC.Console.HTML.OUTPUT_append=function(C,B){if(WC.Console.OBJ_OUTPUT){WC.Console.OBJ_OUTPUT.insertAdjacentHTML("beforeEnd",C);if(B){WC.Console.HTML._DATA.OUTPUT_ELEMENTS_NOW.push(B);if(WC.Console.HTML._DATA.OUTPUT_ELEMENTS_NOW.length>WC.Console.HTML._DATA.OUTPUT_ELEMENTS_MAX){var A=WC.Console.HTML._DATA.OUTPUT_ELEMENTS_NOW.shift();if(A){WC.Console.HTML.OUTPUT_remove_top(A)}}}}};WC.Console.HTML.OUTPUT_remove_top=function(D){if(WC.Console.OBJ_OUTPUT){if(WC.Console.OBJ_OUTPUT.hasChildNodes()){var A=[];var E=0;var F=WC.Console.OBJ_OUTPUT.childNodes;for(var B=0;B<F.length;B++){A.push(F[B]);if(F[B].id&&F[B].id==D){E=1;break}}if(E){for(var C in A){WC.Console.OBJ_OUTPUT.removeChild(A[C]);WC.Console.Hooks.chech_focused_FIX_GRAB()}}}}};WC.Console.HTML.OUTPUT_remove=function(B){if(WC.Console.OBJ_OUTPUT){if(WC.Console.OBJ_OUTPUT.hasChildNodes()){var C=WC.Console.OBJ_OUTPUT.childNodes;for(var A=0;A<C.length;A++){if(C[A].id&&C[A].id==B){WC.Console.OBJ_OUTPUT.removeChild(C[A]);WC.Console.Hooks.chech_focused_FIX_GRAB();break}}}}};WC.Console.HTML.OUTPUT_set_mark=function(C,A){if(C&&A){var B=WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(C);if(B){B.wc_mark=A}}};WC.Console.HTML.OUTPUT_get_mark=function(B){if(B){var A=WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(B);if(A&&A.wc_mark){return A.wc_mark}}return""};WC.Console.HTML.OUTPUT_reset=WC.Console.HTML.OUTPUT_empty=function(){if(WC.Console.OBJ_OUTPUT){WC.Console.OBJ_OUTPUT.innerHTML="";WC.Console.HTML.add_powered_by();WC.Console.DATA.PROMPT_is_fosuced=1}};WC.Console.HTML.add_powered_by=function(){var A=WC.Console.HTML._get_id();WC.Console.HTML.OUTPUT_append('<div id="'+A+'" class="block-powered-by"><a href="http://www.web-console.org" target="_blank">Powered by Web Console</a><br /><a href="http://www.web-console.org/donate/" target="_blank">&gt; Support us &lt;</a></div>',A)};WC.Console.HTML.add_welcome=function(C,B,A){if(typeof C=="undefined"){C=1}if(typeof B=="undefined"){B=1}if(typeof A=="undefined"){A=0}var E=WC.Console.HTML._get_id();var D='<div id="'+E+'" class="block-message">';if(C){D+='<span class="t-title">Welcome to Web Console</span><br />&nbsp;&nbsp;&nbsp;Web Console is a web-based application that allow to execute<br />&nbsp;&nbsp;&nbsp;shell commands on a web server directly from a browser.<br />&nbsp;&nbsp;&nbsp;Please type command and press &quot;<span class="t-link">Enter</span>&quot; to execute it on the web server.<br /><br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To clean screen use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'clear\\'); return false" title="Click to paste at command input">clear</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'cls\\'); return false" title="Click to paste at command input">cls</a>&quot; command.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To change current directory use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'cd\\'); return false" title="Click to paste at command input">cd</a>&quot; command.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To autocomplete feature press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To access Web Console internal commands/settings, please type &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'#\\'); return false" title="Click to paste at command input">#</a>&quot; and press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot;<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key on your keyboard.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To start file manager use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'#file manager\\'); return false" title="Click to paste at command input">#file manager</a>&quot; command.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To view/edit Web Console configuration use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'#settings\\'); return false" title="Click to paste at command input">#settings</a>&quot; command.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To use <span class="t-mark">copy/paste feature by right mouse button</span> - click right mouse button on selected<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; text (text will be copied to clipboard), to paste copied text - click right mouse button<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; anywhere again.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To get information about most common Web Console usage, please read <a href="http://www.web-console.org/usage/" target="_blank" title="Read Web Console Usage">Web Console Usage</a>.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> If you have any questions, please visit to <a href="http://forum.web-console.org" target="_blank" title="Visit to Web Console FORUM">Web Console FORUM</a>.<br />'}else{D+='<span class="t-title">Welcome to Web Console</span>'}if(!A){D+='<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span> <a class="t-link-notUL" href="http://www.web-console.org/about_us/" title="Read more information about Web Console Group" target="_blank">Web Console Group</a> provides web application development, server configuration,<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span> technical support, security analysis, consulting and other services.<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span> To get more information about it please visit to <a href="http://services.web-console.org" title="Read more information about Web Console Group services" target="_blank">Web Console Group services</a> page.';D+="<br /><br />"+WC.Console.HTML.get_DONATION_HTML()}if(B){if(NL.Browser.Detect.isOPERA){D+=""+(!A?"<br /><br />":"<br />")+'<span class="t-alert">Warning to Opera browser users:</span><br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> Due to some Opera browser restrictions, to use <span class="t-mark">copy/paste feature by right mouse<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  button</span> - hold &quot;<span class="t-cmd" title="Press and hold &lt;CTRL&gt; key on your keyboard">CTRL</span>&quot; key on your keyboard and press LEFT mouse button.';if(A){D+="<br />"}}}if(A){D+="<br />"+WC.Console.HTML.get_DEMO_HTML()}D+="</div>";WC.Console.HTML.OUTPUT_append(D,E)};WC.Console.HTML.get_DONATION_HTML=function(C){var A="";var B="&nbsp;&nbsp;&nbsp;";if(C){B="&nbsp;&nbsp;";A='<div class="t-green">'}A+=""+B+'<span class="t-dash">*************************************************************************************</span><br />'+B+'<span class="t-dash">**</span> The Web Console team is working very hard to provide an easy, light and highly &nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> useful web-based remote console. Web Console is available for free, and will &nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> always be available for free. If you enjoy and use Web Console, please consider <span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <a class="a-brown" href="http://www.web-console.org/donate/" title="Donate to Web Console project" target="_blank">supporting the Web Console project financially</a>. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-red-dark">Any contributions are very important for us.</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">*************************************************************************************</span>';if(C){A+="</div>"}return A};WC.Console.HTML.get_DEMO_HTML=function(){var A="";var B="&nbsp;&nbsp;&nbsp;";A+=""+B+'<span class="t-dash">*************************************************************************************</span><br />'+B+'<span class="t-dash">**</span> <span class="t-lime">Web Console is working at DEMO MODE, not all features are enabled at this mode.</span> <span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-blue">Following commands are allowed at DEMO mode:</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'ls\\'); return false" title="Click to paste at command input">ls</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'dir\\'); return false" title="Click to paste at command input">dir</a>&quot; - list directory contents; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'echo\\'); return false" title="Click to paste at command input">echo</a>&quot; - displays entered message; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'clear\\'); return false" title="Click to paste at command input">clear</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'cls\\'); return false" title="Click to paste at command input">cls</a>&quot; - clears screen; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-dash">--</span> Type &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\\'#\\'); return false" title="Click to paste at command input">#</a>&quot; and press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard to access Web Console internal <span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> &nbsp;&nbsp; commands (at DEMO MODE limited access to that commands allowed); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-dash">--</span> To autocomplete feature press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <span class="t-blue">Fully featured Web Console version can be downloaded here:</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">**</span> <a class="t-link" href="http://www.web-console.org/download/" title="Visit to Web Console Download" target="_blank">http://www.web-console.org/download/</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+B+'<span class="t-dash">*************************************************************************************</span>';return A};WC.Console.HTML.set_INNER=function(C,A){if(C&&typeof (A)!="undefined"){var B=xGetElementById(C);if(B){B.innerHTML=NL.String.toHTML(A)}}};WC.Console.HTML.add_time_message=function(E,B,C){if(E&&typeof (B)!="undefined"){if(!C){C={}}if(!C.TIME){C.TIME=5}if(typeof C.IS_HTML=="undefined"){C.IS_HTML=0}var D=xGetElementById(E);if(D){var A=""+(new Date()).getTime()+"-"+Math.random();D.timer_MARK=A;D.innerHTML=C.IS_HTML?B:NL.String.toHTML(B);setTimeout("var o = xGetElementById('"+E+"'); if (o && o['timer_MARK']=='"+A+"') o.innerHTML = '&nbsp;';",C.TIME*1000)}}};WC.Console.HTML.add_cmd_message=function(B,D){var C=B?B:"";var A=D?D:"";WC.Console.HTML.add_command(C,A);WC.Console.Prompt.scroll_to()};WC.Console.HTML.add_command=function(F,A){var C=F?F:"";var E="";var D={id:WC.Console.HTML._get_id()};D.id_timer="";D.id_command=D.id+"_command";D.id_result=D.id+"_result";if(A){E=A}else{D.id_timer=D.id+"_timer";E='<span class="t-wait">&nbsp;&nbsp;waiting...&nbsp;<span id="'+D.id_timer+'" class="t-timer">00:00:00</span></span>'}var B=(WC.Console.OBJ_PROMPT_PREFIX&&WC.Console.OBJ_PROMPT_PREFIX.innerHTML)?WC.Console.OBJ_PROMPT_PREFIX.innerHTML:WC.Console.Prompt.prefix_value_get_default();WC.Console.HTML.OUTPUT_append('<div id="'+D.id+'" class="block-cmd"><div id="'+D.id_command+'" class="block-cmd-command">'+B+C+'</div><div id="'+D.id_result+'" class="block-cmd-result">'+E+"</div></div>",D.id);return D};WC.Console.HTML.add_TAB=function(A){return WC.Console.HTML.add_command('<span class="t-brown"><span class="t-blue">***</span> TAB <span class="t-blue">(AUTOCOMPLETION)</span></span>',A?A:"")};WC.Console.HTML.get_MESSAGE_TITLE=function(B){var A="";if(B=="info"){A="INFORMATIONAL MESSAGE:"}else{if(B=="error"){A="ERROR MESSAGE:"}else{if(B=="warning"){A="WARNING MESSAGE:"}else{A="UNKNOWN MESSAGE:"}}}return'<div class="custom-report-TITLE">'+A+"</div>"};WC.Console.HTML.get_ERROR=function(A){return'<div class="block-error">'+A+"</div>"};WC.Console.HTML.message_str_right=function(D,C,E){var B=NL.String.get_str_right_dottes(D,(C&&C>0)?C:60);var A='<span class="'+((E&&E!="")?E:"s-link")+'"';if(D.length>B.length){A+=' style="cursor: help; font-style: normal" title="'+NL.String.toHTML(D,1)+'">'}else{A+=">"}return A+NL.String.toHTML(B,1)+"</span>"};WC.Console.HTML.get_AJAX_error=function(B,C){var A='<div class="t-lime" style="margin-left: 16px">AJAX ERROR:</div><div class="block-error" style="margin-left: 16px">'+NL.String.toHTML(B).replace(/\\n/g,"<br />")+"</div>";if(typeof C!="undefined"&&C!=""){A+='<div class="t-red-dark" style="margin-left: 16px">'+C+"</div>"}return A};WC.Console.status_change=function(E,B,A){if(!B){B="Idle"}if(E){var D=xGetElementById(E);if(D){var G=B;var C=E+"-TIMER";if(A){if(G!=""){G+=" "}var F="#b66640";G+='<span style="color:'+F+'">[<span id="'+C+'" style="color:'+F+'">00:00:00</span>]</span>'}D.innerHTML=G;if(A){return C}}}};if(typeof WC=="undefined"){alert("WC UI: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("UI")}WC.UI._DATA={CONST:{prefix_ID:"wc-ui-",prefix_CLASS:"wc-ui-",TAB_SUFFIX:"tab-"},DYNAMIC:{id:0}};WC.UI._get_ID=function(){WC.UI._DATA.DYNAMIC["id"]=WC.UI._DATA.DYNAMIC["id"]+1;return WC.UI._DATA.DYNAMIC["id"]};WC.UI._tab_get_DIV_obj=function(A,B){if(A&&B&&A.indexOf(B)==0){var C=A.substr(B.length);if(C){return xGetElementById(C)}}return null};WC.UI.tab_activate=function(J,L,E){if(J&&L){if(typeof E=="undefined"){E=1}var B=J+"-menu-TR";var H=xGetElementById(B);if(H){if(H.hasChildNodes()){var K=WC.UI._DATA.CONST["prefix_CLASS"]+"tab-menu-element-ACTIVE";var I=J+"-menu-element-";var F=null;var A=null;var G=H.childNodes;for(var D=G.length-1;D>=0;D--){if(xHasClass(G[D],K)){F=G[D];if(A){if(A==F){return true}else{break}}}if(G[D].hasChildNodes()){var C=G[D].firstChild;if(C&&C.innerHTML&&C.innerHTML==L){A=G[D];if(F){if(F==A){return true}else{break}}}}}WC.UI._tab_activate(B,A.id,I,E?1:0);return true}}}return false};WC.UI._tab_activate=function(C,A,G,H){if(A&&C&&G){if(typeof H=="undefined"){H=1}var B=xGetElementById(A);var J=xGetElementById(C);if(B&&J){var K=WC.UI._DATA.CONST["prefix_CLASS"]+"tab-menu-element-ACTIVE";if(!xHasClass(B,K)){var L;var E=0,D=0;if(J.hasChildNodes()){var I=J.childNodes;for(var F=I.length-1;F>=0;F--){if(xHasClass(I[F],K)){if(I[F].id){L=WC.UI._tab_get_DIV_obj(I[F].id,G);if(L&&L.style){if(H){E=xWidth(L);D=xHeight(L)}L.style.display="none"}}xRemoveClass(I[F],K);break}}}xAddClass(B,K);L=WC.UI._tab_get_DIV_obj(A,G);if(L&&L.style){if(E>0&&D>0){L.style.width=E+"px";L.style.height=D+"px"}L.style.display="block"}return true}}}return false};WC.UI.tab_set=function(A,E,D,B){if(A){var C=xGetElementById(A);if(C){if(!E){E=""}if(!D){D=""}if(!B){B={}}C.innerHTML=WC.UI.tab(E,D,B)}}};WC.UI.tab_write=function(){document.write(WC.UI.tab(arguments))};WC.UI.tab=function(C,K,G){if(!C){C=""}if(!K){K=""}if(!G){G={}}var H=G.ID?G.ID:WC.UI._DATA.CONST["prefix_ID"]+"tab-"+WC.UI._get_ID();var J=(typeof G.MENU_DIV_SIZE_SAME=="undefined"||G.MENU_DIV_SIZE_SAME)?1:0;var B="",P="";if(G.MENU){B="-menu";var L=H+"-menu-element-";var E=H+"-menu-TR";var N="",M=0;for(var F in G.MENU){if(G.MENU[F]["id"]){var A=L+G.MENU[F]["id"];var O="";if(G.MENU[F]["active"]){O=' class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-menu-element-ACTIVE"'}N+='<td id="'+A+'"'+O+'><span unselectable="on" onclick="WC.UI._tab_activate(\\''+E+"', '"+A+"', '"+L+"', "+J+'); return false">'+F+"</span></td>";M++}}N+='<td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-menu-element-space">&nbsp</td>';P='<tr><td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-menu"><table class="grid"><tr id="'+E+'">'+N+"</tr></table></td></tr>"}var D="";if(G.BOTTOM){D='<tr><td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-bottom">'+G.BOTTOM+"</td></tr>"}var I="";if(typeof G.WIDTH!="undefined"&&G.WIDTH=="FULL-AUTO"){I='style="width: 100%" '}return'<table class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab" '+I+'id="'+H+'"><tr><td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-top"><table class="grid"><tr><td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+"tab-title"+B+'">'+C+'</td><td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-title-center">&nbsp;</td></tr></table></td></tr>'+P+'<tr><td class="'+WC.UI._DATA.CONST["prefix_CLASS"]+'tab-main">'+K+"</td></tr>"+D+"</table>"};if(typeof WC=="undefined"){alert("WC UI Filemanager: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("UI.Filemanager")}WC.UI.Filemanager._DATA={CONST:{prefix_ID:"wc-ui-fm-",prefix_CLASS:"wc-ui-fm-"},DYNAMIC:{id:0}};WC.UI.Filemanager.activate=function(C,A){if(C&&A&&A.id_files_selected){if(!xHasClass(C,"back")){var B=xGetElementById(A.id_files_selected);var E=parseInt(B.innerHTML);var D=WC.UI.Filemanager._DATA.CONST["prefix_CLASS"]+"element-ACTIVE";if(!xHasClass(C,D)){xAddClass(C,D);if(B){B.innerHTML=E+1}}else{xRemoveClass(C,D);if(B&&E>0){B.innerHTML=E-1}}}}};WC.UI.Filemanager.status_change=function(C,B,A){return WC.Console.status_change(C?C:"",B?B:"",A?A:0)};WC.UI.Filemanager.double_click=function(B,F,E){if(B&&B.innerHTML&&F){var A=xGetElementById("_wc-file-manager-PATH-"+F);var G=xGetElementById("_wc_file_manager_PATH-UPDATE-"+F);if(A&&G){var D=NL.String.fromHTML(B.innerHTML);WC.Console.HTML.set_INNER("_wc_file_manager_STATUS-MESSAGE-"+F,"");if(E&&E=="file"){WC.Console.Exec.CMD_INTERNAL("OPENING FILE &quot;"+NL.String.toHTML(NL.String.get_str_right(D,40,1))+"&quot;","#file open",{"-dir":A.value},[D])}else{var C=WC.UI.Filemanager.status_change("_wc_file_manager_STATUS-"+F,"Changing path",1);WC.Console.Exec.CMD_INTERNAL("CHANGING PATH","#file _manager_ACTION",{ACTION:"go",dir:A.value,js_ID:F,update_path:1,go_path:D,synchronize_global_path:(G.checked)?1:0},[],{type:"hidden",id_TIMER:C})}}else{alert("Unable to find File Manager objects (internal error)")}}};WC.UI.Filemanager.make_unselectable=function(B){if(B){var A=xGetElementById(B);if(A){WC.UI.Filemanager._selection_ACTION(A,"UNSELECTABLE")}}};WC.UI.Filemanager.selection_clear=function(D,C){if(D&&C){var B=xGetElementById(D);var A=xGetElementById(C);if(B&&A){var E=parseInt(A.innerHTML);if(E>0){WC.UI.Filemanager._selection_ACTION(B,"CLEAR");A.innerHTML=0}}}};WC.UI.Filemanager.selection_all=function(D,C){if(D&&C){var B=xGetElementById(D);var A=xGetElementById(C);if(B&&A){A.innerHTML=WC.UI.Filemanager._selection_ACTION(B,"ALL")}}};WC.UI.Filemanager.selection_regex=function(E,D,B){if(E&&D&&B){var C=xGetElementById(E);var A=xGetElementById(D);if(C&&A){A.innerHTML=WC.UI.Filemanager._selection_ACTION(C,"REGEX",{regex:new RegExp(B)})}}};WC.UI.Filemanager.selection_get=function(D,C){if(D&&C){var B=xGetElementById(D);var A=xGetElementById(C);if(B&&A){var E=parseInt(A.innerHTML);if(E>0){return WC.UI.Filemanager._selection_ACTION(B,"GET")}}}return[]};WC.UI.Filemanager._selection_ACTION=function(I,G,C){var D=typeof (G)!="undefined"?G:"";var E=0;var B=[];if(I&&I.hasChildNodes()){var H=I.childNodes;for(var F=0;F<H.length;F++){var A=0;if(NL.Browser.Detect.isFF||NL.Browser.Detect.isOPERA){A=(H[F] instanceof HTMLDivElement)}else{A=(H[F].tagName.toLowerCase()=="div")}if(A){if((!xHasClass(H[F],"free")||D=="UNSELECTABLE")&&(!xHasClass(H[F],"back")||D=="UNSELECTABLE")){if(D=="UNSELECTABLE"){NL.UI.object_make_unselectable(H[F])}else{var J=WC.UI.Filemanager._DATA.CONST["prefix_CLASS"]+"element-ACTIVE";if(xHasClass(H[F],J)){if(D=="CLEAR"){xRemoveClass(H[F],J)}else{if(D=="GET"){B.push(NL.String.fromHTML(H[F].innerHTML))}else{if(D=="ALL"){E++}else{if(D=="REGEX"){E++}}}}}else{if(D=="ALL"){xAddClass(H[F],J);E++}else{if(D=="REGEX"){if(C&&C.regex&&H[F].innerHTML.match(C.regex)){xAddClass(H[F],J);E++}}}}}}}else{if(H[F].hasChildNodes()){if(D=="CLEAR"||D=="UNSELECTABLE"){WC.UI.Filemanager._selection_ACTION(H[F],D)}else{if(D=="GET"){B=B.concat(WC.UI.Filemanager._selection_ACTION(H[F],D))}else{if(D=="ALL"){E+=WC.UI.Filemanager._selection_ACTION(H[F],D)}else{if(D=="REGEX"){E+=WC.UI.Filemanager._selection_ACTION(H[F],D,(C)?C:{})}}}}}}}}if(D=="GET"){return B}else{if(D=="ALL"){return E}else{if(D=="REGEX"){return E}}}};if(typeof WC=="undefined"){alert("WC UI Upload: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("UI.Upload")}WC.UI.Upload._DATA={CONST:{prefix_ID:"wc-ui-fm-",prefix_CLASS:"wc-ui-fm-"},DYNAMIC:{id:0}};WC.UI.Upload.update_dir_list=function(C,A){if(A&&A.id){var G=50;var F=xGetElementById("wc-upload-dir-list-"+A.id);if(F){if(document.createElement&&(F.options.add||F.add)){F.length=1;for(var D in C){var B=C[D];var E=document.createElement("OPTION");E.value=C[D];E.text=" "+NL.String.get_str_right(B,G,1)+" ";(F.options.add)?F.options.add(E):F.add(E,null)}if(F.length>1){}else{F.selectedIndex=0}}}}};WC.UI.Upload.slots=function(F,L){if(L&&L.id&&L.input_class){var K=xGetElementById("wc-upload-files-area-"+L.id);if(K){var D=5;var C=1;var B=K.lastChild;var I="wc-upload-button-slot-plus-"+L.id;var E="wc-upload-button-slot-minus-"+L.id;if(B&&B.type=="file"){var J=/-(\\d{0,})\$/.exec(B.name);if(J.length==2){C=J[1]}if(F=="remove"){if(C>1){if(K.removeChild(B)){B=K.lastChild;if(B&&B.nodeName&&B.nodeName.toLowerCase()=="br"){K.removeChild(B)}}if(C==2){var G=xGetElementById(E);if(!xHasClass(G,"wc-upload-div-button-unactive")){xAddClass(G,"wc-upload-div-button-unactive")}}if(C==D){var A=xGetElementById(I);if(A){A.innerHTML="+1 upload slot"}}}}else{if(C<D){C++;var H=document.createElement("input");H.type="file";H.id=L.id+"-wc-upload-file-"+C;H.name="_"+L.id+"-wc-upload-file-"+C;if(NL.Browser.Detect.isFF&&L.ff_size){H.size=L.ff_size}xAddClass(H,L.input_class);K.appendChild(document.createElement("br"));K.appendChild(H);if(C>1){var G=xGetElementById(E);if(xHasClass(G,"wc-upload-div-button-unactive")){xRemoveClass(G,"wc-upload-div-button-unactive")}}if(C==D){var A=xGetElementById(I);if(A){A.innerHTML="[ "+D+" is MAX ]"}}}}}}}};WC.UI.Upload.start=function(C,B){if(C&&B){var A=NL.Upload.upload(C,{params:{q_action:"AJAX_UPLOAD",user_login:B.user_login,user_password:B.user_password,dir:B.dir,dir_sub:B.dir_sub,dir_create:B.dir_create,file_permissions:B.file_permissions,mode_ASCII:B.mode_ASCII,js_ID:B.js_ID},files:B.FILES,callbacks:{uploaded:function(D,E){if(D&&D.CODE&&D.CODE!="OK"){WC.Console.HTML.add_cmd_message('<span class="t-brown"><span class="t-blue">***</span> UPLOADING FILE(S)</span>',D.MESSAGE?D.MESSAGE:"");WC.UI.Upload.state_PROGRESS_CANCEL(E.js_ID)}else{if(D.UPLOADS&&D.INFO){WC.UI.Upload.state_FINAL(D.INFO,D.UPLOADS)}}},timer:function(){},status:function(){}}},{js_ID:B.js_ID});return A}return 0};WC.UI.Upload.state_SHOW=function(A){if(A&&A.style){A.style.display="block"}};WC.UI.Upload.state_HIDE=function(A){if(A&&A.style){A.style.display="none"}};WC.UI.Upload.state_FIX_WIDTH=function(A){if(A){var B=xWidth(A);if(B&&B>0){if(A.style){A.style.width=B+"px"}}}};WC.UI.Upload.state_FINAL=function(N,D){if(N&&D&&N.js_ID){var I=xGetElementById("wc-upload-layout-div-PROGRESS-"+N.js_ID);var B=xGetElementById("wc-upload-layout-div-PROGRESS-TAB-"+N.js_ID);var K=xGetElementById("wc-upload-layout-div-FINISH-"+N.js_ID);if(I&&B&&K){var A=xWidth(B);var Q=A>0?' style="width: '+A+'px"':"";var E=(N.files_chmod&&N.files_chmod!="undefined"&&N.files_chmod!="")?'<tr><td class="area-left-short"><span class="wc-upload-name">Files CHMOD\\'ed:</span></td><td class="area-right-long"><span class="wc-upload-chmod">'+NL.String.toHTML(N.files_chmod)+"</span></td></tr>":"";var H=50;var P=0;var O=0;var C="";var G="";for(var M in D){P++;if(D[M]["status"]){O++;if(C!=""){C+="<br />"}C+='<span class="wc-upload-file-good-main">- '+WC.Console.HTML.message_str_right(D[M]["file"],H,"wc-upload-file-good")+' <span class="wc-upload-file-good-size">('+NL.String.get_str_of_bytes(D[M]["size"])+")</span></span>";if(D[M]["ERROR_MSG"]&&D[M]["ERROR_MSG"]!=""){C+='<br /><span class="wc-upload-file-good-info">('+D[M]["ERROR_MSG"]+")</span>"}}else{if(G!=""){G+="<br />"}G+='<span class="wc-upload-file-bad-main">- '+WC.Console.HTML.message_str_right(D[M]["file"],H,"wc-upload-file-bad")+' <span class="wc-upload-file-bad-size">('+NL.String.get_str_of_bytes(D[M]["size"])+")</span></span>";if(D[M]["ERROR_MSG"]&&D[M]["ERROR_MSG"]!=""){G+='<br /><span class="wc-upload-file-bad-info">('+D[M]["ERROR_MSG"]+")</span>"}}}var J=(O>0)?'<tr><td class="area-left-short" style="vertical-align: top"><span class="wc-upload-name">Uploaded files:</span></td><td class="area-right-long">'+C+"</td></tr>":"";var F=(P>O)?'<tr><td class="area-left-short" style="vertical-align: top"><span class="wc-upload-name">Not uploaded files:</span></td><td class="area-right-long">'+G+"</td></tr>":"";WC.UI.Upload.state_FIX_WIDTH(K);var L='<table id="wc-upload-layout-div-FINAL-TAB-'+N.js_ID+'" class="grid"'+Q+'><tr><td colspan="2" style="padding-bottom: 3px"><table class="grid" style="width: 100%"><tr><td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Uploading results:</span></td><td class="wc-upload-info-right">&nbsp;</td></tr></table></td></tr><tr><td class="area-left-short"><span class="wc-upload-name">Files uploaded into directory:</span></td><td class="area-right-long">'+WC.Console.HTML.message_str_right(N.dir_current)+'</td></tr><tr><td class="area-left-short"><span class="wc-upload-name">Total files uploaded:</span></td><td class="area-right-long"><span class="wc-upload-total-files">'+O+" of "+P+'</span></td></tr><tr><td class="area-left-short"><span class="wc-upload-name">Uploaded files size:</span></td><td class="area-right-long"><span class="wc-upload-files-size">~'+NL.String.get_str_of_bytes(N.size_total)+'</span></td></tr><tr><td class="area-left-short"><span class="wc-upload-name">Time spent:</span></td><td class="area-right-long"><span class="wc-upload-time">'+NL.Timer.get_str_time(N.time_spent,1)+"</span></td></tr>"+E+J+F+'<tr><td class="wc-upload-td-buttons" colspan="2"><table class="grid"><tr><td class="area-button-left"><div id="wc-upload-FINAL-button-close-'+N.js_ID+'" class="div-button w-100">close</div></td><td class="area-button-right"><div id="wc-upload-FINAL-button-new-'+N.js_ID+'" class="div-button w-120">new upload</div></td><td class="area-button-right"><div id="wc-upload-FINAL-button-RMBELOW-'+N.js_ID+'" class="div-button w-270">Remove all messages below this box</div></td></tr></table></td></tr></table>';K.innerHTML=L;NL.UI.div_button_register("div-button","wc-upload-FINAL-button-close-"+N.js_ID,function(){WC.Console.HTML.OUTPUT_remove_result("wc-upload-layout-div-MAIN-"+N.js_ID)});NL.UI.div_button_register("div-button","wc-upload-FINAL-button-RMBELOW-"+N.js_ID,function(){WC.Console.HTML.OUTPUT_remove_below("wc-upload-layout-div-MAIN-"+N.js_ID)});NL.UI.div_button_register("div-button","wc-upload-FINAL-button-new-"+N.js_ID,function(){WC.Console.HTML.OUTPUT_remove_result("wc-upload-layout-div-MAIN-"+N.js_ID);WC.Console.Exec.CMD_INTERNAL("STARTING NEW UPLOADING FORM","#file upload")});WC.UI.Upload.state_HIDE(I);WC.UI.Upload.state_SHOW(K)}}};WC.UI.Upload.state_FINAL_no_RESULT=function(A){if(A&&A.js_ID){var F=xGetElementById("wc-upload-layout-div-PROGRESS-"+A.js_ID);var B=xGetElementById("wc-upload-layout-div-PROGRESS-TAB-"+A.js_ID);var C=xGetElementById("wc-upload-layout-div-FINISH-"+A.js_ID);if(F&&B&&C){var G=xWidth(B);var E=G>0?' style="width: '+G+'px"':"";WC.UI.Upload.state_FIX_WIDTH(C);var D='<table id="wc-upload-layout-div-FINAL-TAB-'+A.js_ID+'" class="grid"'+E+'><tr><td colspan="2" style="padding-bottom: 3px"><table class="grid" style="width: 100%"><tr><td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Uploading results:</span></td><td class="wc-upload-info-right">&nbsp;</td></tr></table></td></tr><tr><td class="area-left-short" colspan="2"><span class="wc-upload-NO-RESULT">Looks like files has been successfully uploaded, but browser does not receive uploading results from server.<br />If browser will receive uploading results, that message will be updated.<br />Please check your browser version, and, if necessary, install the latest version.</span></td></td></tr><tr><td class="wc-upload-td-buttons" colspan="2"><table class="grid"><tr><td class="area-button-left"><div id="wc-upload-FINAL-button-close-'+A.js_ID+'" class="div-button w-100">close</div></td><td class="area-button-right"><div id="wc-upload-FINAL-button-new-'+A.js_ID+'" class="div-button w-120">new upload</div></td><td class="area-button-right"><div id="wc-upload-FINAL-button-RMBELOW-'+A.js_ID+'" class="div-button w-270">Remove all messages below this box</div></td></tr></table></td></tr></table>';C.innerHTML=D;NL.UI.div_button_register("div-button","wc-upload-FINAL-button-close-"+A.js_ID,function(){WC.Console.HTML.OUTPUT_remove_result("wc-upload-layout-div-MAIN-"+A.js_ID)});NL.UI.div_button_register("div-button","wc-upload-FINAL-button-RMBELOW-"+A.js_ID,function(){WC.Console.HTML.OUTPUT_remove_below("wc-upload-layout-div-MAIN-"+A.js_ID)});NL.UI.div_button_register("div-button","wc-upload-FINAL-button-new-"+A.js_ID,function(){WC.Console.HTML.OUTPUT_remove_result("wc-upload-layout-div-MAIN-"+A.js_ID);WC.Console.Exec.CMD_INTERNAL("STARTING NEW UPLOADING FORM","#file upload")});WC.UI.Upload.state_HIDE(F);WC.UI.Upload.state_SHOW(C)}}};WC.UI.Upload.state_PROGRESS_IS_ACTIVE=function(A){if(A){var B=xGetElementById("wc-upload-layout-div-PROGRESS-"+A);if(B&&B.style&&B.style.display!="none"){return 1}}return 0};WC.UI.Upload.state_PROGRESS_STOP=function(B){if(B){var A=xGetElementById("wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-"+B);if(A){A.value="0";return 1}}return 0};WC.UI.Upload.state_PROGRESS_CANCEL=function(A){if(A){var B=xGetElementById("wc-upload-layout-div-PROGRESS-"+A);if(B&&B.style&&B.style.display!="none"){var C=xGetElementById("wc-upload-layout-div-MAIN-"+A);if(C){WC.UI.Upload.state_HIDE(B);WC.UI.Upload.state_SHOW(C);B.innerHTML="";WC.Console.status_change("wc-upload-STATUS-"+A);WC.Console.Prompt.scroll_to()}}}};WC.UI.Upload.state_PROGRESS=function(H){if(H&&H.js_ID){var I=xGetElementById("wc-upload-layout-div-MAIN-"+H.js_ID);var B=xGetElementById("wc-upload-layout-div-MAIN-TAB-"+H.js_ID);var C=xGetElementById("wc-upload-layout-div-PROGRESS-"+H.js_ID);if(I&&B&&C){var A=xWidth(B);var J=A>0?' style="width: '+A+'px"':"";WC.UI.Upload.state_FIX_WIDTH(C);var G='<span class="wc-upload-loading">[loading]</span>';var D=(H.UPLOAD_STATUS_METHOD&&H.UPLOAD_STATUS_METHOD=="STATUS_FILE");var F="";if(D){F='<tr><td class="progress-left">Uploading file:</td><td class="progress-main" id="wc-upload-progress-FILES-'+H.js_ID+'">'+G+'</td></tr><tr><td class="progress-left">Current file name:&nbsp;</td><td class="progress-main" id="wc-upload-progress-FILE-'+H.js_ID+'">'+G+"</td></tr>"}var E='<form id="wc-upload-PROGRESS-FORM-'+H.js_ID+'" name="_wc-upload-PROGRESS-FORM-'+H.js_ID+'" method="post" enctype="multipart/form-data" onsubmit="return false"><input id="wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-'+H.js_ID+'" type="hidden" name="_wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-'+H.js_ID+'" value="0" /><input id="wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+H.js_ID+'" type="hidden" name="_wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+H.js_ID+'" value="1" /><input id="wc-upload-PROGRESS-FORM-STATUS_REQUESTED-'+H.js_ID+'" type="hidden" name="_wc-upload-PROGRESS-FORM-STATUS_REQUESTED-'+H.js_ID+'" value="0" /><input id="wc-upload-PROGRESS-FORM-TIME_SPENT-'+H.js_ID+'" type="hidden" name="_wc-upload-PROGRESS-FORM-TIME_SPENT-'+H.js_ID+'" value="0" /><input id="wc-upload-PROGRESS-FORM-SIZE_CURRENT-'+H.js_ID+'" type="hidden" name="_wc-upload-PROGRESS-FORM-SIZE_CURRENT-'+H.js_ID+'" value="0" /><table id="wc-upload-layout-div-PROGRESS-TAB-'+H.js_ID+'" class="grid"'+J+'><tr><td colspan="2"><table class="grid" style="width: 100%"><tr><td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Uploading progress:</span></td><td class="wc-upload-info-right">&nbsp;</td></tr></table></td></tr><tr><td colspan="2"><table class="wc-upload-progress"><tr><td class="wc-upload-progress-td-percents">Uploading progress: <span id="wc-upload-progress-PERCENTS-'+H.js_ID+'">0</span>%</td></tr><tr><td class="wc-upload-progress-td-bar"><div class="wc-upload-progress-div-bar"><div class="wc-upload-progress-div-subbar" id="wc-upload-progress-BAR-'+H.js_ID+'"></div></div></td></tr><tr><td class="wc-upload-progress-td-approx">Approx speed: <span id="wc-upload-progress-SPEED_APPROX-'+H.js_ID+'">'+G+'</span></td></tr><tr><td class="wc-upload-td-info"><table class="wc-upload-progress-info">'+F+'<tr><td class="progress-left">Current position:&nbsp;</td><td class="progress-main" id="wc-upload-progress-POSITION-'+H.js_ID+'">'+G+'</td></tr><tr><td class="progress-left">Time spent:&nbsp;</td><td class="progress-main" id="wc-upload-progress-TIME_SPENT-'+H.js_ID+'">00:00:00</td></tr><tr><td class="progress-left">Time left:&nbsp;</td><td class="progress-main" id="wc-upload-progress-TIME_LEFT-'+H.js_ID+'">'+G+'</td></tr></table></td></tr></table></td></tr><tr><td class="wc-upload-td-buttons" colspan="2"><table class="grid"><tr><td class="area-button-left" id="wc-upload-PROGRESS-button-stop-AREA-'+H.js_ID+'"><div id="wc-upload-PROGRESS-button-stop-'+H.js_ID+'" class="div-button w-120">stop</div></td><td class="area-button-right"><div id="wc-upload-PROGRESS-button-close-'+H.js_ID+'" class="div-button w-120">close</div></td><td class="area-button-right"><div id="wc-upload-PROGRESS-button-RMBELOW-'+H.js_ID+'" class="div-button w-270">Remove all messages below this box</div></td></tr></table></td></tr></table></form>';C.innerHTML=E;NL.UI.div_button_register("div-button","wc-upload-PROGRESS-button-RMBELOW-"+H.js_ID,function(){WC.Console.HTML.OUTPUT_remove_below("wc-upload-layout-div-MAIN-"+H.js_ID)});NL.UI.div_button_register("div-button","wc-upload-PROGRESS-button-stop-"+H.js_ID,function(){WC.UI.Upload.STOP(H.js_ID)});NL.UI.div_button_register("div-button","wc-upload-PROGRESS-button-close-"+H.js_ID,function(){WC.UI.Upload.STOP(H.js_ID);WC.Console.HTML.OUTPUT_remove_result("wc-upload-layout-div-MAIN-"+H.js_ID)});WC.UI.Upload.state_HIDE(I);WC.UI.Upload.state_SHOW(C)}}};WC.UI.Upload.STOP=function(A){if(A){var C=NL.Cache.get(A);if(C){C.abort();NL.Cache.remove(A);WC.UI.Upload.state_PROGRESS_STOP(A);var B=xGetElementById("wc-upload-progress-TIME_LEFT-"+A);if(B){B.innerHTML='<span class="wc-upload-STOPED">[uploading stopped]</span>'}C=xGetElementById("wc-upload-PROGRESS-button-stop-AREA-"+A);if(C){C.innerHTML='<div id="wc-upload-PROGRESS-button-new-'+A+'" class="div-button w-120">new upload</div>';NL.UI.div_button_register("div-button","wc-upload-PROGRESS-button-new-"+A,function(){WC.Console.HTML.OUTPUT_remove_result("wc-upload-layout-div-MAIN-"+A);WC.Console.Exec.CMD_INTERNAL("STARTING NEW UPLOADING FORM","#file upload")})}}}};WC.UI.Upload.state_PROGRESS_update_TIME=function(E,D){if(E&&E.js_ID){var B=xGetElementById("wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-"+E.js_ID);if(B&&B.value&&parseInt(B.value)){var G=30;var A=D/1000;if(A-parseInt(B.value)>G){WC.UI.Upload.state_FINAL_no_RESULT(E);return 0}}var I=xGetElementById("wc-upload-PROGRESS-FORM-STATUS_REQUESTED-"+E.js_ID);var F=xGetElementById("wc-upload-PROGRESS-FORM-TIME_SPENT-"+E.js_ID);var C=xGetElementById("wc-upload-progress-TIME_SPENT-"+E.js_ID);if(F&&C){F.value=D;C.innerHTML=NL.Timer.get_str_time(D)}var H=3000;if(I&&!parseInt(I.value)&&(D%H)==0){I.value=1;return 1}}return 0};WC.UI.Upload.state_PROGRESS_update=function(F,S,V){if(F&&V&&F.js_ID){var C=(V.UPLOAD_STATUS_METHOD&&V.UPLOAD_STATUS_METHOD=="STATUS_FILE");var J=xGetElementById("wc-upload-PROGRESS-FORM-SIZE_CURRENT-"+F.js_ID);var A=xGetElementById("wc-upload-progress-PERCENTS-"+F.js_ID);var I=xGetElementById("wc-upload-progress-BAR-"+F.js_ID);var X=xGetElementById("wc-upload-progress-SPEED_APPROX-"+F.js_ID);var D=xGetElementById("wc-upload-progress-POSITION-"+F.js_ID);var P=xGetElementById("wc-upload-progress-TIME_LEFT-"+F.js_ID);var Q=xGetElementById("wc-upload-PROGRESS-FORM-TIME_SPENT-"+F.js_ID);var K=null;var W=null;if(C){K=xGetElementById("wc-upload-progress-FILES-"+F.js_ID);W=xGetElementById("wc-upload-progress-FILE-"+F.js_ID)}if(J&&A&&I&&X&&D&&P&&Q&&(!C||(K&&W))){if(S.size_current>parseInt(J.value)){var H="[FINISHED, PROCESSING FILE(S), PLEASE WAIT]";J.value=S.size_current;var T=S.size_current;var G=S.size_total;var Z=(S.status&&S.status=="FINISHED");var Y=Q.value/1000;var L=T/Y;var B=Math.floor((T/G)*100);var E=NL.String.get_str_of_bytes(T)+" of "+NL.String.get_str_of_bytes(G);if(Z){X.innerHTML=NL.String.toHTML(H,1)}else{X.innerHTML=NL.String.toHTML(NL.String.get_str_of_bytes(L)+"/s",1)}A.innerHTML=NL.String.toHTML(B,1);I.style.width=NL.String.toHTML(""+B+"%",1);if(C){var O=80;var N=S.file_current_number+" of "+V.FILES_TOTAL;var R=S.file_current_name;if(Z){K.innerHTML=NL.String.toHTML(H,1);W.innerHTML=NL.String.toHTML(H,1)}else{K.innerHTML=NL.String.toHTML(N,1);W.innerHTML=WC.Console.HTML.message_str_right(R,O)}}if(Z){P.innerHTML=NL.String.toHTML(H,1)}else{P.innerHTML=NL.Timer.get_str_time(Math.ceil((G-T)/L),1)}D.innerHTML=NL.String.toHTML(E,1);if(B>=100){var M=xGetElementById("wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-"+F.js_ID);if(M){M.value="0"}var U=xGetElementById("wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-"+F.js_ID);if(U){U.value=Y}}}return 1}}return 0};if(typeof WC=="undefined"){alert("WC.Console.Autocomplete: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.Autocomplete")}WC.Console.Autocomplete.CMD=function(A){if(!WC.Console.Autocomplete.CMD_INTERNAL(A)){var B=WC.Console.HTML.add_TAB();WC.Console.Prompt.scroll_to();if(B.id_timer!=""){NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER,{id:B.id_timer})}WC.Console.AJAX.query({},{q_action:"AJAX_TAB",cmd_query:A},WC.Console.Response.AJAX_CALLBACK,{hash_IDs:B})}};WC.Console.Autocomplete.CMD_INTERNAL=function(A){var B=A;return 0;return 1};if(typeof WC=="undefined"){alert("WC.Console.Clipboard: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.Clipboard")}WC.Console.Clipboard._DATA={CLIPBOARD:""};WC.Console.Clipboard.set=function(A){if(A){WC.Console.Clipboard._DATA.CLIPBOARD=A;WC.Console.Clipboard.set_REAL(A)}};WC.Console.Clipboard.get=function(){return WC.Console.Clipboard.get_REAL()||WC.Console.Clipboard._DATA.CLIPBOARD};WC.Console.Clipboard.set_REAL=function(A){if(A&&window.clipboardData){window.clipboardData.setData("Text",A);return true}return false};WC.Console.Clipboard.get_REAL=function(){if(window.clipboardData){return window.clipboardData.getData("Text")||""}return""};WC.Console.Clipboard.selection_empty=function(A){if(!NL.Browser.Detect.isOPERA){if(A){if(A.selection){A.selection.empty()}else{if(A.getSelection){A.getSelection().removeAllRanges()}else{if(NL.Browser.Detect.isFF){A.setSelectionRange(A.selectionStart,A.selectionStart)}}}}else{if(document.selection){document.selection.empty()}else{if(window.getSelection){window.getSelection().removeAllRanges()}else{if(document.getSelection){document.getSelection().removeAllRanges()}}}}}};WC.Console.Clipboard.selection_get=function(){var C=window;var B=document;var D="",A;if(C.getSelection){D=C.getSelection()}else{if(B.getSelection){D=B.getSelection()}else{if(B.selection&&B.selection.createRange){A=B.selection.createRange();D=A.text}else{alert("NO")}}}D=""+D;return D};WC.Console.Clipboard.selection_get_OBJ=function(A){var F="";if(A){var E=xGetElementById(A);if(E){if(E.createTextRange){var D=document.selection.createRange().duplicate();F=D.text}else{var B=E.selectionStart;var C=E.selectionEnd;if(C>B){F=E.value.substring(B,C)}}}}return F};if(typeof WC=="undefined"){alert("WC.Console.Prompt: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.Prompt")}WC.Console.Prompt._DATA={PROMPT_PREFIX_VALUE:""};WC.Console.Prompt.init=function(){if(WC.Console.OBJ_PROMPT_PREFIX){if(WC.Console.OBJ_PROMPT_PREFIX.innerHTML&&WC.Console.OBJ_PROMPT_PREFIX.innerHTML!=""){WC.Console.Prompt._DATA.PROMPT_PREFIX_VALUE=WC.Console.OBJ_PROMPT_PREFIX.innerHTML}if(WC.Console.State.DIR_CURRENT!=""){WC.Console.Prompt.prefix_value_set_dir(WC.Console.State.DIR_CURRENT)}}};WC.Console.Prompt.scroll_to=function(){if(WC.Console.OBJ_PROMPT_PREFIX.scrollIntoView){WC.Console.OBJ_PROMPT_PREFIX.scrollIntoView(true);if(NL.Browser.Detect.isOPERA){window.scrollBy(-xDocSize().w,0)}}else{if(window.scrollBy){var A=xDocSize();window.scrollBy(-A.w,A.h)}}};WC.Console.Prompt.activate=function(){WC.Console.Prompt.scroll_to();WC.Console.Prompt.cursor_position_set((WC.Console.DATA.PROMPT_cursor_position>=0)?WC.Console.DATA.PROMPT_cursor_position:-1)};WC.Console.Prompt.value_set=function(G,D,F){if(WC.Console.OBJ_PROMPT&&typeof G!="undefined"){if(typeof D!="undefined"&&D>=0){var E=WC.Console.OBJ_PROMPT.value;if(E.length>=D){var C=E.substr(0,D);if(typeof F!="undefined"&&F>0){var B=(E.length>D+F)?E.substr(D+F):"";WC.Console.OBJ_PROMPT.value=C+G+B}else{WC.Console.OBJ_PROMPT.value=C+G+E.substr(D)}var A=C.length+G.length;WC.Console.Prompt.cursor_position_set(A)}}else{WC.Console.OBJ_PROMPT.value=G;WC.Console.Prompt.cursor_position_set(-1)}}};WC.Console.Prompt.value_get=function(){return WC.Console.OBJ_PROMPT?WC.Console.OBJ_PROMPT.value:""};WC.Console.Prompt.value_get_left_part=function(){if(WC.Console.OBJ_PROMPT){var A=WC.Console.Prompt.cursor_position_get();if(A>=0&&WC.Console.OBJ_PROMPT.value.length>=A){return WC.Console.OBJ_PROMPT.value.substr(0,A)}}return""};WC.Console.Prompt.selection_set=function(A,B){if(WC.Console.OBJ_PROMPT){if(WC.Console.OBJ_PROMPT.selectionStart){WC.Console.OBJ_PROMPT.focus();WC.Console.OBJ_PROMPT.setSelectionRange(A,B);return true}}return 0};WC.Console.Prompt.cursor_position_set=function(B){if(WC.Console.OBJ_PROMPT){if(typeof B=="undefined"||B<0){B=(WC.Console.OBJ_PROMPT.value&&WC.Console.OBJ_PROMPT.value.length)?WC.Console.OBJ_PROMPT.value.length:0}if(WC.Console.OBJ_PROMPT.createTextRange){var A=WC.Console.OBJ_PROMPT.createTextRange();A.move("character",B);A.select();return 1}else{if(WC.Console.OBJ_PROMPT.selectionStart){WC.Console.OBJ_PROMPT.focus();WC.Console.OBJ_PROMPT.setSelectionRange(B,B);if(B==0){WC.Console.OBJ_PROMPT.focus()}return 1}else{WC.Console.OBJ_PROMPT.focus()}}}return 0};WC.Console.Prompt.cursor_position_get=function(){if(WC.Console.OBJ_PROMPT){var B=WC.Console.OBJ_PROMPT;if(B.createTextRange){var A=document.selection.createRange().duplicate();A.moveEnd("character",B.value.length);if(A.text==""){return B.value.length}else{return B.value.lastIndexOf(A.text)}}else{return B.selectionStart||0}}return 0};WC.Console.Prompt.paste=function(D,E){if(WC.Console.OBJ_PROMPT&&D&&D!=""){if(!E){D=NL.String.trim(NL.String.toLINE(D))}var B=WC.Console.Prompt.cursor_position_get();if(B<0){B=WC.Console.DATA.PROMPT_cursor_position}if(B>WC.Console.OBJ_PROMPT.value.length){B=WC.Console.OBJ_PROMPT.value.length;WC.Console.OBJ_PROMPT.value+=D}else{if(B<=0){B=0;WC.Console.OBJ_PROMPT.value=D+WC.Console.OBJ_PROMPT.value}else{var C=WC.Console.OBJ_PROMPT.value.substr(0,B);var A=WC.Console.OBJ_PROMPT.value.substr(B);WC.Console.OBJ_PROMPT.value=C+D+A}}WC.Console.DATA.PROMPT_cursor_position=B+D.length;WC.Console.Prompt.activate();return true}return false};WC.Console.Prompt.prefix_value_set=function(A){if(WC.Console.OBJ_PROMPT_PREFIX&&typeof (A)!="undefined"){WC.Console.OBJ_PROMPT_PREFIX.innerHTML=A}};WC.Console.Prompt.prefix_value_get_default=function(){return WC.Console.Prompt._DATA.PROMPT_PREFIX_VALUE};WC.Console.Prompt.prefix_value_reset=function(){if(WC.Console.Prompt._DATA.PROMPT_PREFIX_VALUE!=""){WC.Console.Prompt.prefix_value_set(WC.Console.Prompt._DATA.PROMPT_PREFIX_VALUE)}};WC.Console.Prompt.prefix_value_set_dir=function(A){if(typeof (A)!="undefined"&&A!=""){WC.Console.Prompt.prefix_value_set(NL.String.toHTML(NL.String.get_str_right_dottes(A,30))+WC.Console.Prompt._DATA.PROMPT_PREFIX_VALUE)}};if(typeof WC=="undefined"){alert("WC.Console.Hooks: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.Hooks")}WC.Console.Hooks._DATA={LAST_FOCUSED_OBJ:null,LAST_FOCUSED_ID:"",OPERA_CLIPBOARD:"",OPERA_PROMPT_LAST_KEY:null};WC.Console.Hooks.init=function(){if(WC.Console.IS_INITIALIZED){if(WC.Console.OBJ_PROMPT_PREFIX){xAddEventListener(WC.Console.OBJ_PROMPT_PREFIX,"click",function(){WC.Console.Prompt.activate();return false},false)}if(WC.Console.OBJ_PROMPT){xAddEventListener(WC.Console.OBJ_PROMPT,"focus",function(){WC.Console.DATA.PROMPT_is_fosuced=1;return true},false);xAddEventListener(WC.Console.OBJ_PROMPT,"blur",function(){WC.Console.DATA.PROMPT_is_fosuced=0;return true},false);xAddEventListener(WC.Console.OBJ_PROMPT,"click",WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE,false);xAddEventListener(WC.Console.OBJ_PROMPT,"keyup",WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE,false);xAddEventListener(WC.Console.OBJ_PROMPT,"keypress",WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE,false);xAddEventListener(WC.Console.OBJ_PROMPT,"mouseup",WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE,false);xAddEventListener(WC.Console.OBJ_PROMPT,"mousedown",WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE,false);if(NL.Browser.Detect.isFF){WC.Console.OBJ_PROMPT.onkeydown=WC.Console.Hooks.prompt_KEYPRESS_FF_UP_DOWN}}if(NL.Browser.Detect.isIE||NL.Browser.Detect.isSAFARI){document.onkeydown=WC.Console.Hooks.global_KEYPRESS}else{if(NL.Browser.Detect.isOPERA){xAddEventListener(WC.Console.OBJ_PROMPT,"focus",function(){WC.Console.Hooks._DATA.OPERA_PROMPT_LAST_KEY=null},false);xAddEventListener(WC.Console.OBJ_PROMPT,"blur",function(){if(WC.Console.Hooks._DATA.OPERA_PROMPT_LAST_KEY==9){this.focus();return false}return true},false);xAddEventListener(WC.Console.OBJ_PROMPT,"keydown",function(A){if(A.keyCode&&A.keyCode==9){WC.Console.Hooks._DATA.OPERA_PROMPT_LAST_KEY=A.keyCode}},false);document.onkeypress=WC.Console.Hooks.global_KEYPRESS}else{document.onkeypress=WC.Console.Hooks.global_KEYPRESS}}if(NL.Browser.Detect.isIE||NL.Browser.Detect.isFF||NL.Browser.Detect.isSAFARI){document.oncontextmenu=WC.Console.Hooks.global_ONCONTEXTMENU}else{if(NL.Browser.Detect.isOPERA){xAddEventListener(document,"keydown",function(A){if(A.ctrlKey){WC.Console.Hooks._DATA.OPERA_CLIPBOARD=WC.Console.Clipboard.selection_get()||(WC.Console.OBJ_PROMPT?WC.Console.Clipboard.selection_get_OBJ(WC.Console.OBJ_PROMPT):"")}else{WC.Console.Hooks._DATA.OPERA_CLIPBOARD=""}},false);document.onclick=function(A){if(A.ctrlKey){WC.Console.Hooks.global_ONCONTEXTMENU(null,WC.Console.Hooks._DATA.OPERA_CLIPBOARD);return false}}}}}};WC.Console.Hooks.GRAB_OFF=function(A){WC.Console.Hooks._DATA.LAST_FOCUSED_OBJ=A;WC.Console.Hooks._DATA.LAST_FOCUSED_ID=A.id?A.id:"";WC.Console.DATA.GLOBAL_is_grab_input=0};WC.Console.Hooks.GRAB_ON=function(A){WC.Console.Hooks._DATA.LAST_FOCUSED_OBJ=null;WC.Console.Hooks._DATA.LAST_FOCUSED_ID="";WC.Console.DATA.GLOBAL_is_grab_input=1};WC.Console.Hooks.chech_focused_FIX_GRAB=function(){if(WC.Console.Hooks._DATA.LAST_FOCUSED_ID){if(!xGetElementById(WC.Console.Hooks._DATA.LAST_FOCUSED_ID)){WC.Console.Hooks._DATA.LAST_FOCUSED_ID="";WC.Console.Hooks._DATA.LAST_FOCUSED_OBJ=null;WC.Console.DATA.GLOBAL_is_grab_input=1}}};WC.Console.Hooks.global_ONCONTEXTMENU=function(C,B){var A=(B)?B:WC.Console.Clipboard.selection_get();if(A==""){if(WC.Console.OBJ_PROMPT){A=WC.Console.Clipboard.selection_get_OBJ(WC.Console.OBJ_PROMPT);WC.Console.Clipboard.selection_empty(WC.Console.OBJ_PROMPT)}}else{WC.Console.Clipboard.selection_empty()}if(A!=""){WC.Console.Clipboard.set(A)}else{var D=WC.Console.Clipboard.get();if(D!=""){WC.Console.Prompt.paste(D)}else{WC.Console.Prompt.activate()}}return false};WC.Console.Hooks.prompt_KEYPRESS_FF_UP_DOWN=function(A){if(WC.Console.DATA.PROMPT_is_fosuced){if(A){if(A.keyCode==38){WC.Console.ACTION("UP");return false}else{if(A.keyCode==40){WC.Console.ACTION("DOWN");return false}}}}return true};WC.Console.Hooks.global_KEYPRESS=function(G){if(!WC.Console.DATA.GLOBAL_is_grab_input&&!(NL.Browser.Detect.isOPERA&&WC.Console.DATA.PROMPT_is_fosuced)){return }var F="";var D=0;var B=0;var A=null;if(window.event){A=window.event}else{if(parent&&parent.event){A=parent.event}else{if(G){A=G;B=1}}}if(A){if((A.keyCode==68&&A.ctrlKey)||(B&&A.keyCode==0&&A.charCode==100&&A.ctrlKey)){F="CTRL-D"}else{if(A.keyCode==116){D=1}else{if(A.ctrlKey){D=1}else{if(WC.Console.DATA.PROMPT_is_fosuced){if(A.keyCode==13){F="ENTER"}else{if(A.keyCode==38){F="UP"}else{if(A.keyCode==40){F="DOWN"}else{if(A.keyCode==9){F="TAB"}}}}if(window.scrollBy){if(A.keyCode==36){var C=xScrollLeft();if(C){window.scrollBy(-C,0)}return true}else{if(A.keyCode==35){var E=xDocSize();if(E.w>0){window.scrollBy(E.w,0)}return true}}}}}}}}if(F==""){if(!WC.Console.DATA.PROMPT_is_fosuced&&!D){WC.Console.Prompt.activate();return false}}else{if(!(NL.Browser.Detect.isFF&&(F=="UP"||F=="DOWN"))){WC.Console.ACTION(F)}return false}return true};WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE=function(){WC.Console.DATA.PROMPT_is_fosuced=1;WC.Console.DATA.GLOBAL_is_grab_input=1;var A=WC.Console.Prompt.cursor_position_get();if(A>=0){WC.Console.DATA.PROMPT_cursor_position=A}return true};if(typeof WC=="undefined"){alert("WC.Console.History: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.History")}WC.Console.History._DATA={MAX_LENGHT:30,CURRENT_NUM:0,LIST:[]};WC.Console.History.add=function(A){if(A){if(WC.Console.History._DATA.LIST.length<=0||(WC.Console.History._DATA.LIST[WC.Console.History._DATA.LIST.length-1]!=A)){WC.Console.History._DATA.LIST.push(A);if(WC.Console.History._DATA.LIST.length>WC.Console.History._DATA.MAX_LENGHT){WC.Console.History._DATA.LIST.shift()}}WC.Console.History._DATA.CURRENT_NUM=WC.Console.History._DATA.LIST.length}};WC.Console.History.reset=WC.Console.History.empty=function(){WC.Console.History._DATA.LIST=[];WC.Console.History._DATA.CURRENT_NUM=0};WC.Console.History.up=function(){if(WC.Console.History._DATA.LIST.length>0){if(WC.Console.History._DATA.CURRENT_NUM>0){WC.Console.History._DATA.CURRENT_NUM--;return WC.Console.History._DATA.LIST[WC.Console.History._DATA.CURRENT_NUM]}else{return WC.Console.History._DATA.LIST[0]}}WC.Console.History._DATA.CURRENT_NUM=0;return""};WC.Console.History.down=function(){if(WC.Console.History._DATA.LIST.length>0){if(WC.Console.History._DATA.CURRENT_NUM+1<WC.Console.History._DATA.LIST.length){WC.Console.History._DATA.CURRENT_NUM++;return WC.Console.History._DATA.LIST[WC.Console.History._DATA.CURRENT_NUM]}else{WC.Console.History._DATA.CURRENT_NUM=WC.Console.History._DATA.LIST.length;return""}}WC.Console.History._DATA.CURRENT_NUM=0;return""};if(typeof WC=="undefined"){alert("WC.Console.AJAX: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.AJAX")}WC.Console.AJAX._DATA={url:"$WC_HTML{'js_APP_SETTINGS_FILE_NAME'}"};WC.Console.AJAX._params_parse=function(C){for(var B in C){if(typeof C[B]=="object"){for(var A in C[B]){if(typeof C[B+"_"+A]=="undefined"){C[B+"_"+A]=C[B][A]}}delete C[B]}}return C};WC.Console.AJAX.query=function(D,A,E,C,B){if(!D){D={}}if(!A){A={}}if(typeof A.user_login=="undefined"&&typeof WC.Console.State.USER_LOGIN!="undefined"){A.user_login=WC.Console.State.USER_LOGIN}if(typeof A.user_password=="undefined"&&typeof WC.Console.State.USER_PASSWORD_ENCRYPTED!="undefined"){A.user_password=WC.Console.State.USER_PASSWORD_ENCRYPTED}if(typeof A.STATE!="object"){A.STATE=WC.Console.State.get_JS()}D=WC.Console.AJAX._params_parse(D);A=WC.Console.AJAX._params_parse(A);NL.AJAX.query(WC.Console.AJAX._DATA.url,D,A,function(F){E(F,C?C:{})},(B)?true:false,C?C:null)};if(typeof WC=="undefined"){alert("WC.Console.Response: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("WC.Console.Response")}WC.Console.Response._DATA={LAST_DIR_CHANGE_ID:0};WC.Console.Response.AJAX_CALLBACK=function(in_JS_DATA,in_STASH){if(in_JS_DATA){var is_HIDDEN=(in_STASH.type&&in_STASH.type=="hidden");if(in_STASH&&((in_STASH.hash_IDs&&in_STASH.hash_IDs["id_result"])||is_HIDDEN)){var obj=(is_HIDDEN)?null:xGetElementById(in_STASH.hash_IDs["id_result"]);if(obj||is_HIDDEN){var is_CRITICAL=0;var SET_result="";var EXEC_JS="";var INPUTS_EDITABLE=0;var AJAX_text=(typeof in_JS_DATA.text!="undefined")?in_JS_DATA.text:"";if(in_JS_DATA.action&&in_JS_DATA.action!=""){if(in_JS_DATA.action=="INFO"||in_JS_DATA.action=="ERROR"||in_JS_DATA.action=="WARNING"){SET_result=WC.Console.HTML.get_MESSAGE_TITLE(in_JS_DATA.action.toLowerCase())+AJAX_text;is_CRITICAL=1}else{if(in_JS_DATA.action=="CMD_RESULT"){SET_result=AJAX_text;if(in_JS_DATA.action_params){if(in_JS_DATA.action_params["JS_CODE"]){EXEC_JS=in_JS_DATA.action_params["JS_CODE"]}if(in_JS_DATA.action_params["INPUTS_EDITABLE"]){INPUTS_EDITABLE=1}}}else{if(in_JS_DATA.action=="DIR_CHANGE"){if(in_JS_DATA.action_params&&in_JS_DATA.action_params["dir_now"]){var update_dir=1;if(in_JS_DATA.action_params["JS_REQUEST_ID"]){update_dir=0;if(WC.Console.Response._DATA.LAST_DIR_CHANGE_ID<=0||WC.Console.Response._DATA.LAST_DIR_CHANGE_ID<in_JS_DATA.action_params["JS_REQUEST_ID"]){WC.Console.Response._DATA.LAST_DIR_CHANGE_ID=in_JS_DATA.action_params["JS_REQUEST_ID"];update_dir=1}}if(update_dir){WC.Console.State.change_dir(in_JS_DATA.action_params["dir_now"]);SET_result='<div class="t-lime">Current Web Console directory is: "'+WC.Console.HTML.message_str_right(in_JS_DATA.action_params["dir_now"])+'"</div>'}}}else{if(in_JS_DATA.action=="TAB_RESULT"){if(in_JS_DATA.action_params){if(typeof in_JS_DATA.action_params["str_IN"]!="undefined"&&((typeof in_JS_DATA.action_params["ALWAYS_SHOW"]!="undefined"&&in_JS_DATA.action_params["ALWAYS_SHOW"])||WC.Console.Prompt.value_get_left_part()==in_JS_DATA.action_params["str_IN"])){if(typeof in_JS_DATA.action_params["TITLE"]!="undefined"&&in_JS_DATA.action_params["TITLE"]!=""){SET_result+='<div class="t-lime">'+in_JS_DATA.action_params["TITLE"]+"</div>"}if(typeof in_JS_DATA.action_params["INFO"]!="undefined"&&in_JS_DATA.action_params["INFO"]!=""){SET_result+='<div class="t-green-light">'+in_JS_DATA.action_params["INFO"]+"</div>"}if(typeof in_JS_DATA.action_params["SUBTITLE"]!="undefined"&&in_JS_DATA.action_params["SUBTITLE"]!=""){SET_result+='<div class="t-blue">'+in_JS_DATA.action_params["SUBTITLE"]+"</div>"}if(typeof in_JS_DATA.action_params["TEXT"]!="undefined"&&in_JS_DATA.action_params["TEXT"]!=""){SET_result+="<div>"+in_JS_DATA.action_params["TEXT"]+"</div>"}if(in_JS_DATA.action_params["JS_CODE"]){EXEC_JS=in_JS_DATA.action_params["JS_CODE"]}if(in_JS_DATA.action_params["INPUTS_EDITABLE"]){INPUTS_EDITABLE=1}if(typeof in_JS_DATA.action_params["cmd_left_update"]!="undefined"&&in_JS_DATA.action_params["cmd_left_update"]!=""){WC.Console.Prompt.value_set(in_JS_DATA.action_params["cmd_left_update"],0,String(in_JS_DATA.action_params["str_IN"]).length)}else{if(typeof in_JS_DATA.action_params["cmd_add"]!="undefined"&&in_JS_DATA.action_params["cmd_add"]!=""){WC.Console.Prompt.paste(in_JS_DATA.action_params["cmd_add"],1)}}}if(typeof in_JS_DATA.action_params["values"]=="object"){var str_variants="";for(var i in in_JS_DATA.action_params["values"]){if(str_variants!=""){str_variants+="<br />"}str_variants+=in_JS_DATA.action_params["values"][i]}SET_result+=str_variants}}}}}}}if(!is_HIDDEN||is_CRITICAL){if(obj){if(SET_result!=""){obj.innerHTML=SET_result}else{if(AJAX_text!=""){obj.innerHTML=AJAX_text}else{obj.innerHTML="";obj.parentNode.removeChild(obj)}}}else{WC.Console.HTML.add_cmd_message('<span class="t-red"><span class="t-blue">***</span> CRITICAL MESSAGE</span>',SET_result||AJAX_text)}}if(EXEC_JS!=""){eval(EXEC_JS)}if(!is_HIDDEN){if(INPUTS_EDITABLE){WC.Console.Response.set_input_editable(obj)}WC.Console.Prompt.scroll_to()}if(in_STASH.hash_SETTINGS){if(in_STASH.hash_SETTINGS["func_callback"]){in_STASH.hash_SETTINGS["func_callback"](in_JS_DATA,in_STASH)}}}}}};WC.Console.Response.set_input_editable=function(C){if(C){var F=0;if(C.tagName){var D=(C.tagName)?C.tagName.toLowerCase():"";if(D=="input"){var B=(C.type)?C.type.toLowerCase():"";if(B=="text"||B=="password"||B=="checkbox"||B=="radio"){F=1}}else{if(D=="select"){F=1}else{if(D=="textarea"){F=1;NL.UI.input_allow_tab(C)}}}}if(F){xAddEventListener(C,"focus",function(G){WC.Console.Hooks.GRAB_OFF(C)},false);xAddEventListener(C,"blur",function(G){WC.Console.Hooks.GRAB_ON(C)},false)}else{(C.hasChildNodes())}var E=C.childNodes;for(var A=0;A<E.length;A++){WC.Console.Response.set_input_editable(E[A])}}};WC.Console.Response.AJAX_ERROR=function(B,C){var D=0;if(typeof C!="undefined"&&C){if(C.hash_IDs&&C.hash_IDs["id_result"]){var E=xGetElementById(C.hash_IDs["id_result"]);if(E){D=1;var A="";if(B.match(/^JavaScript code generated by backend is invalid![ \\s\\t\\r\\n]{0,}\$/)){A="* Looks like too slow connection or connection has been closed by server."}E.innerHTML=WC.Console.HTML.get_AJAX_error(B,A);WC.Console.Prompt.scroll_to()}}}if(!D&&WC.Console.State.FLAG_SHOW_WARNINGS){alert("AJAX ERROR:\\n"+B)}};if(typeof WC=="undefined"){alert("WC.Console.Exec: Error - object WC is not defiend, maybe 'WC CORE' is not loaded")}else{WC.namespace("Console.Exec")}WC.Console.Exec.CMD_INTERNAL=function(C,F,K,J,E){if(!C){C=""}if(!K){K={}}if(!J){J=[]}if(!E){E={}}if(F){var A="";for(var B in K){if(A!=""){A+=" "}A+='"'+NL.String.toLINE_escape(B)+'"="'+NL.String.toLINE_escape(K[B])+'"'}for(var D in J){if(A!=""){A+=" "}A+='"'+NL.String.toLINE_escape(J[D])+'"'}if(A!=""){var L=(F.length>0)?F.charAt(F.length-1):"";if(L!=" "){F+=" "}}F+=A;var H=(E.type&&E.type=="hidden");var G={};if(!H){G=WC.Console.HTML.add_command('<span class="t-brown"><span class="t-blue">***</span> '+C+"</span>");WC.Console.Prompt.scroll_to();if(G.id_timer!=""){NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER,{id:G.id_timer})}}if(E.id_TIMER){NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER,{id:E.id_TIMER})}var I={hash_IDs:G,hash_SETTINGS:E};if(H){I.type="hidden"}WC.Console.AJAX.query({},{q_action:"AJAX_CMD",cmd_query:F},WC.Console.Response.AJAX_CALLBACK,I)}};WC.Console.Exec.CMD=function(A){if(!WC.Console.Exec.CMD_BROWSER(A)){var B=WC.Console.HTML.add_command(A);WC.Console.Prompt.scroll_to();if(B.id_timer!=""){NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER,{id:B.id_timer})}WC.Console.AJAX.query({},{q_action:"AJAX_CMD",cmd_query:A},WC.Console.Response.AJAX_CALLBACK,{hash_IDs:B})}};WC.Console.Exec.CMD_BROWSER=function(A){var B=A;if(B.match(/^(cls|clear)[ ]{0,}\$/i)){WC.Console.Exec.action_CLEAR()}else{return 0}return 1};WC.Console.Exec.action_CLEAR=function(){WC.Console.HTML.OUTPUT_reset();WC.Console.Prompt.activate();WC.Console.DATA.PROMPT_is_fosuced=1;WC.Console.DATA.GLOBAL_is_grab_input=1};xAddEventListener(window,"load",WC_ONLOAD_EVENT,false);function WC_ONLOAD_EVENT(){WC.Console.init_and_start("input-query","area-output","area-command-prefix");if(NL.Browser.Detect.isOPERA){var B=xGetElementById("area-bottom-tr");if(B){var A=document.createElement("td");var C=document.createElement("input");C.setAttribute("id","input-opera-TAB-FIX");C.setAttribute("name","_input-opera-TAB-FIX");C.setAttribute("type","text");C.setAttribute("style","width: 0; height: 0; border: 0;");C.setAttribute("autocomplete","off");C.setAttribute("onfocus","WC.Console.Prompt.activate()");A.appendChild(C);B.appendChild(A)}}};
//--></script>
</head>
<body>
<table id="layout"><tr><td id="layout-td">
	<table id="layout-internal">
	<tr><td id="area-output" colspan="2">&nbsp;</td></tr>
	<tr>
		<td id="area-bottom">
			<table class="grid"><tr id="area-bottom-tr">
				<td id="area-command-prefix-td"><span id="area-command-prefix">&gt;&nbsp;</span></td>
				<td id="area-command">
					<form id="form-MAIN" action="" method="post" autocomplete="off" onsubmit="return false">
						<input id="input-query" type="text" name="_input-query" autocomplete="off" />
					</form>
					<script type="text/JavaScript"><!--
						// Setting INFO
						WC.Console.SET_USER("$WC_HTML{'user_login'}", "$WC_HTML{'user_password_encrypted'}");
						WC.Console.State.set('DIR_CURRENT', "$WC_HTML{'dir_current'}");
						WC.Console.State.set('FLAG_SHOW_WELCOME', $WC_HTML{'flag_show_welcome'});
						WC.Console.State.set('FLAG_SHOW_WARNINGS', $WC_HTML{'flag_show_warnings'});
						WC.Console.State.set('IS_DEMO', $WC_HTML{'IS_DEMO'});
						// Additional JavaScript
						WC.Console.additional_JAVASCRIPT = function() {
							$WC_HTML{'ADDITIONAL_JAVASCRIPT'}
						};
					//--></script>
				</td>
			</tr></table>
		</td>
	</tr>
	</table>
</td></tr></table>
</body>
</html>

_HTML_CODE_EOF
}}package WC::HTML::Report;
use strict;
$WC::HTML::Report::DATA={'DYNAMIC'=>{'IS_DATA_LOADED'=>0,'DATA'=>{}}};
sub _init_DATA{$WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}={'SETTINGS_MAIN'=>{'VALUES_TO_HTML'=>1,'TYPES'=>['ERROR','WARNING','INFORMATION'],'REQUIRED_IN'=>['TYPE','message'],'TEMPLATES'=>{'_ELEMENTS_SPLITTER_'=>'<div class="report-SPLITTER"></div>','_REPORT_TYPES_'=>{'ERROR'=>'<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-ERROR">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>','WARNING'=>'<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-WARNING">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>','INFORMATION'=>'<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-INFORMATION">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>','_REPORT_ELEMENTS_'=>{'ERROR'=>'<span class="report-t-ERROR">ERROR:</span>&nbsp;[message][_INFO_][_FAQ_ID_ || _FAQ_LINK_]','WARNING'=>'<span class="report-t-WARNING">WARNING:</span>&nbsp;[message][_INFO_][_FAQ_ID_ || _FAQ_LINK_]','INFORMATION'=>'<span class="report-t-INFORMATION">INFORMATION:</span>&nbsp;[message][_INFO_][_FAQ_ID_ || _FAQ_LINK_]','_ELEMENT_PARTS_'=>{'_INFO_'=>'[<div class="report-b-INFO">[info]</div>]','_FAQ_ID_'=>'[<div class="report-b-FAQ">&#187; read solution for that problem at '.'<a href="'.$WC::CONST->{'URLS'}->{'FAQ_ID'}.'[id]" target="_blank" '.'title="Read detailed solution for that problem">Web Console FAQ</a></div>]','_FAQ_LINK_'=>'<div class="report-b-FAQ">&#187; you can try to find solution for that problem at '.'<a href="'.$WC::CONST->{'URLS'}->{'FAQ'}.'" target="_blank" '.'title="Read Web Console FAQ">Web Console FAQ</a></div>'}}}}},'SETTINGS_PARAMETERS'=>{'VALUES_TO_HTML'=>0,'TYPES'=>['ERROR'],'REQUIRED_IN'=>['TYPE','variable','message'],'TEMPLATES'=>{'_ELEMENTS_SPLITTER_'=>'<br />','_REPORT_TYPES_'=>{'ERROR'=>'<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-WARNING">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>','_REPORT_ELEMENTS_'=>{'ERROR'=>'&nbsp;&nbsp;<span class="report-dash">&mdash;</span>&nbsp;\'<span class="report-variable-name"><a href="#" onclick="WC.Other.set_focus(\'[html_element]\'); return false" title="Click to activate that element" onmouseover="if (window) { window.status=\'Click to activate that element\'; } return true" onmouseout="if (window) { window.status=\'\'; } return true">[variable]</a></span>\' [message]','_ELEMENT_PARTS_'=>{}}}}},'REPORT_MAIN'=>{'ALL_title'=>'Details:','ALL_footer'=>'If you need some help, you can visit <a href="http://forum.web-console.org" title="Visit '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM</a>'},'REPORT_INSTALL'=>{'ERROR_title'=>'Permissions problems:','ERROR_footer'=>'Please resolve that problems, after that you can install '.$WC::c->{'APP_SETTINGS'}->{'name'}.'.<br />'.'You can read detailed installation instructions <a href="http://www.web-console.org/installation/" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instruction (with screenshots)" target="_blank">here</a>.','WARNING_title'=>'Installation warnings:','WARNING_footer'=>'You can install '.$WC::c->{'APP_SETTINGS'}->{'name'}.' but we recomend fix that warnings before.<br />'.'You can read detailed installation instructions <a href="http://www.web-console.org/installation/" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instructions (with screenshots)" target="_blank">here</a>.','WARNING_AFTER'=>'<div class="install-TODO">Please enter login, password and e-mail for the new '.$WC::c->{'APP_SETTINGS'}->{'name'}.' administrator:</div>',},'REPORT_PARAMETERS'=>{'ALL_title'=>'Incorrect parameters:','ALL_footer'=>'Please fix that parameters.<br />'.'You can read detailed installation instructions <a href="http://www.web-console.org/installation/" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instruction (with screenshots)" target="_blank">here</a>.','ALL_AFTER'=>'<div class="install-TODO">Please enter login, password and e-mail for the new '.$WC::c->{'APP_SETTINGS'}->{'name'}.' administrator:</div>',},'REPORT_MOD_PERL'=>{'ALL_title'=>'MOD_PERL detected:','ALL_footer'=>'Please configure your web server to run &quot;<b>'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'</b>&quot; script without <b>mod_perl</b>.'}};
$WC::HTML::Report::IS_DATA_LOADED=1;}sub make_REPORT_MAIN{&_init_DATA()if(!$WC::HTML::Report::IS_DATA_LOADED);
return&NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_MAIN'},$_[0],$WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_MAIN'});}sub make_REPORT_INSTALL{&_init_DATA()if(!$WC::HTML::Report::IS_DATA_LOADED);
return&NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_MAIN'},$_[0],$WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_INSTALL'});}sub make_REPORT_MOD_PERL{&_init_DATA();
return&NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_MAIN'},$_[0],$WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_MOD_PERL'});}sub make_REPORT_PARAMETERS{&_init_DATA()if(!$WC::HTML::Report::IS_DATA_LOADED);
return&NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_PARAMETERS'},$_[0],$WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_PARAMETERS'});}package WC::HTML::UI;
use strict;
$WC::HTML::UI::DATA={'CONST'=>{'PREFIX_CLASS'=>'wc-ui'}};
sub tab{my($in_title,$in_text,$in_id)=@_;
$in_title='' if(!defined$in_title);
$in_text='' if(!defined$in_text);
my$table_id='';
$table_id=' id="'.$in_id.'"' if(defined$in_id);
my$result='<table class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab"'.$table_id.'>'.'<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-top">'.'<table class="grid"><tr>'.'<td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-title">'.$in_title.'</td>'.'<td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-title-center">&nbsp;</td>'.'</tr></table>'.'</td></tr>'.'<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-main">'.$in_text.'</td></tr></table>';
return$result;}sub open_container{my($in_file,$in_text,$in_SETTINGS)=@_;
$in_file='' if(!defined$in_file);
$in_text='' if(!defined$in_text);
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'ID'}=&WC::Internal::get_unique_id()if(!defined$in_SETTINGS->{'ID'}||$in_SETTINGS->{'ID'}eq '');
my$table_id=' id="'.$in_SETTINGS->{'ID'}.'"';
my$download=(defined$in_SETTINGS->{'DOWNLOAD'}&&$in_SETTINGS->{'DOWNLOAD'}ne '')?' <span class="t-green">[<a href="'.$in_SETTINGS->{'DOWNLOAD'}.'" class="a-brown" target="_blank" title="Click to download this file">download</a>]</span>':'';
my$close=' <span class="t-green">[<a href="#" onclick="WC.Console.HTML.OUTPUT_remove_result(\''.$in_SETTINGS->{'ID'}.'\'); return false" class="a-brown" target="_blank" title="Click to close">close</a>]</span>';
my$result='<table'.$table_id.' class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-open-container"'.$table_id.'>'.'<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-open-container-title"><span class="t-blue">File '.&WC::HTML::get_short_value($in_file).$download.$close.'</span></td></tr>'.'<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-open-container-main">'.$in_text.'</td></tr></table>';
return$result;}package WC::HTML::Open;
use strict;
sub start{my($file)=@_;
my$result={'ID'=>0,'HTML'=>''};
my$file_ext=($file=~/\.([^\.]{0,})$/)?$1:'';
$file_ext=~s/\.([^\.]{0,})$/$1/;
if(defined$WC::HTML::Open::Types::ALL->{$file_ext}){$result->{'HTML'}=$WC::HTML::Open::Types::ALL->{$file_ext}->($file);
$result->{'ID'}=1;}else{$result->{'HTML'}=$WC::HTML::Open::Types::ALL->{''}->($file);}return$result;}package WC::HTML::Open::Types;
use strict;
sub get_file_paths{my($file)=@_;
my$path_URL=&NL::String::str_HTTP_REQUEST_value($file);
&WC::Dir::update_current_dir();
my$dir_current_ENC_INTERNAL=&WC::Dir::get_current_dir();
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$dir_current_ENC_INTERNAL);
my$dir_current_URL=&NL::String::str_HTTP_REQUEST_value($dir_current_ENC_INTERNAL);
my$user_login_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
my$user_password_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});
return{'open'=>$WC::c->{'APP_SETTINGS'}->{'file_name'}.'?q_action=download'.'&method=open'.'&user_login='.$user_login_URL.'&user_password='.$user_password_URL.'&dir='.$dir_current_URL.'&file='.$path_URL,'download'=>$WC::c->{'APP_SETTINGS'}->{'file_name'}.'?q_action=download'.'&user_login='.$user_login_URL.'&user_password='.$user_password_URL.'&dir='.$dir_current_URL.'&file='.$path_URL};}$WC::HTML::Open::Types::ALL={''=>sub{my($file)=@_;
my$file_ENC=$file;
my$file_SHORT=&WC::HTML::get_short_value($file_ENC);
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC);
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_SHORT);
my$path=&WC::HTML::Open::Types::get_file_paths($file_ENC);
return '<div class="t-blue">&nbsp;&nbsp;-&nbsp;File '.$file_SHORT.' can\'t be opened, unknown file type - <a href="'.$path->{'download'}.'" class="a-brown" target="_blank">click to download</a></div>';},'txt'=>sub{my($file)=@_;
return$WC::Internal::DATA::ALL->{'#file'}->{'edit'}->{'__func__'}->('',{},{'IS_OPEN'=>1,'ARR_FILES'=>[$file]});},'png'=>sub{my($file)=@_;
my$file_ENC=$file;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC);
my$path=&WC::HTML::Open::Types::get_file_paths($file_ENC);
return&WC::HTML::UI::open_container($file_ENC,'<img src="'.$path->{'open'}.'" />'.'',{'DOWNLOAD'=>$path->{'download'}});}};
foreach(split(/\n/, <<END
txt		html htm text cgi pl py php php4 php5 ini cfg conf inc cpp c h
png		jpg jpeg jpe gif bmp tiff ico
END
)){if($_=~/^[ \s\t]{0,}([^ \s\t]+)[ \s\t]{1,}(.+)$/){my$type=$1;
my@arr_ext=split(/ /,&NL::String::str_trim($2));
foreach(@arr_ext){$WC::HTML::Open::Types::ALL->{$_}=$WC::HTML::Open::Types::ALL->{$type}if(defined$WC::HTML::Open::Types::ALL->{$type});}}}package WC::Warning;
use strict;
$WC::Warning::DATA={'CONST'=>{'MAX_MESSAGES'=>20},'DYNAMIC'=>{'messages'=>[]}};
sub _error_reset{&NL::Error::reset(__PACKAGE__);}sub _error_set{&NL::Error::set(__PACKAGE__,@_);}sub get_last_error{&NL::Error::get(__PACKAGE__);}sub get_last_error_ARR{&NL::Error::get_ARR(__PACKAGE__);}sub get_last_error_ID{&NL::Error::get_id(__PACKAGE__);}sub get_last_error_TEXT{&NL::Error::get_text(__PACKAGE__);}sub get_last_error_INFO{&NL::Error::get_info(__PACKAGE__);}sub add{my($message,$info,$id)=@_;
if(defined$message&&$message ne ''){push@{$WC::Warning::DATA->{'DYNAMIC'}->{'messages'}},{'message'=>(defined$message)?$message:'','info'=>(defined$info)?$info:'','id'=>(defined$id)?$id:''};
if(scalar@{$WC::Warning::DATA->{'DYNAMIC'}->{'messages'}}>$WC::Warning::DATA->{'CONST'}->{'MAX_MESSAGES'}){shift@{$WC::Warning::DATA->{'DYNAMIC'}->{'messages'}};}}}sub reset{$WC::Warning::DATA->{'DYNAMIC'}->{'messages'}=[];}sub make_HTML{my$ref_ELEMENTS=[];
foreach(@{$WC::Warning::DATA->{'DYNAMIC'}->{'messages'}}){push@{$ref_ELEMENTS},{'TYPE'=>'WARNING','message'=>(defined$_->{'message'})?$_->{'message'}:'','info'=>(defined$_->{'info'})?$_->{'info'}:'','id'=>(defined$_->{'id'})?$_->{'id'}:''};}if(scalar@{$ref_ELEMENTS}>0){my$report_HTML=&WC::HTML::Report::make_REPORT_MAIN($ref_ELEMENTS);
return$report_HTML->{'TEXT'};}return '';}package WC::Autocomplete;
use strict;
$WC::Autocomplete::IS_OS_WIN32=($^O eq 'MSWin32')?1:0;
sub get_same_part{my($in_ARRAY)=@_;
my$result='';
my$length_ARRAY=scalar@{$in_ARRAY};
if($length_ARRAY>0){my$value_first=$in_ARRAY->[0];
my$same_chars_MIN=length($value_first);
if($same_chars_MIN>0){for(my$v=1;$v<$length_ARRAY;$v++){my$length_v=length($in_ARRAY->[$v]);
my$same_chars=0;
for(my$i=0;($i<$length_v&&$i<$same_chars_MIN);$i++){if(substr($value_first,$i,1)eq substr($in_ARRAY->[$v],$i,1)){$same_chars++;}else{last;}}if($same_chars<=0){$same_chars_MIN=0;last;}elsif($same_chars<$same_chars_MIN){$same_chars_MIN=$same_chars;}}if($same_chars_MIN>0){$result=substr($value_first,0,$same_chars_MIN);}}}return$result;}sub start{my($in_value)=@_;
$in_value='' if(!defined$in_value);
my$result={'ID'=>0,'TITLE'=>'','INFO'=>'','SUBTITLE'=>'','TEXT'=>'','values'=>[],'cmd_add'=>'','cmd_left_update'=>''};
if(!&WC::Dir::change_dir_TO_CURRENT()){&WC::CORE::die_info_AJAX(&WC::Dir::get_last_error_ARR());}else{my$hash_AC={};
$hash_AC=&WC::Internal::start_autocompletion($in_value);
if($hash_AC->{'ID'}){return$hash_AC;}else{my$in_LEFT='';
if($WC::Autocomplete::IS_OS_WIN32){$in_LEFT='';
my$val_CMD=$in_value;
if($val_CMD ne ''){while($val_CMD=~/^([^"]{0,}"(\\[^"]|\\"|[^\\"])+"[ \t\r\n]+|[^"]{0,}[ \t\r\n]+)/){$in_LEFT.=$1;
$val_CMD=$';}}$hash_AC=&DO_AUTOCOMPLETE_DIR($val_CMD);}else{if($in_value=~/(^|.*[^\\] )(((\\[ ])|[^ ]){0,})$/||$in_value=~/(^ )(((\\[ ])|[^ ]){0,})$/){$in_LEFT=defined$1?$1:'';
$hash_AC=&DO_AUTOCOMPLETE_DIR(defined$2?$2:'');}}if($hash_AC->{'ID'}){$hash_AC->{'cmd_left_update'}=$in_LEFT.$hash_AC->{'cmd_left_update'}if($hash_AC->{'cmd_left_update'}ne '');
return$hash_AC;}}}return$result;}sub DO_AUTOCOMPLETE_DIR{my($in_value,$in_sort)=@_;
$in_value='' if(!defined$in_value);
$in_sort=1 if(!defined$in_sort);
my$result={'ID'=>0,'TITLE'=>'','INFO'=>'','SUBTITLE'=>'','TEXT'=>'','values'=>[],'cmd_add'=>'','cmd_left_update'=>''};
my$system_SPLITTER='';
my$default_SPLITTER='';
my$splitters_RE='';
foreach my $spl(&WC::Dir::get_dir_splitters()){if(ref$spl eq 'ARRAY'){foreach(@{$spl}){$splitters_RE.=$_;}}else{$default_SPLITTER=$system_SPLITTER=$spl;
$splitters_RE.=$spl;}}$splitters_RE=quotemeta($splitters_RE);
my$IS_FULL_PATH_UPDATE_NEEDED=0;
my$input_FIXED=&WC::Dir::check_in($in_value);
my$input_DIR='';
my$input_SPLITTER='';
my$input_VAL='';
if($input_FIXED=~/^(.*)([$splitters_RE])([^$splitters_RE]{0,})$/){$input_DIR=(defined$1?$1:'');
$input_SPLITTER=$2;
$input_VAL=(defined$3?$3:'');
if($input_DIR eq ''||($input_VAL eq ''&&$input_DIR=~/^[$splitters_RE]{1,}$/)||($WC::Autocomplete::IS_OS_WIN32&&$input_DIR=~/^[a-zA-Z]+:$/)){$input_DIR.=$input_SPLITTER;
$default_SPLITTER=$input_SPLITTER;
$input_SPLITTER='';}if($input_VAL eq '..'){if($input_DIR=~/^[$splitters_RE]{0,}$/){$input_DIR.=$input_SPLITTER.$input_VAL.($input_SPLITTER||$default_SPLITTER);}else{$input_DIR.=$input_SPLITTER.$input_VAL;}$input_VAL='';
$IS_FULL_PATH_UPDATE_NEEDED=1;}}else{$input_VAL=$input_FIXED;
if($input_VAL eq '..'||$input_VAL eq '.'){$input_DIR=$input_VAL.$system_SPLITTER;
$input_VAL='';
$IS_FULL_PATH_UPDATE_NEEDED=1;}elsif($WC::Autocomplete::IS_OS_WIN32&&$input_VAL=~/^[a-zA-Z]+:$/){$input_DIR=$input_VAL.$default_SPLITTER;
$input_VAL='';
$IS_FULL_PATH_UPDATE_NEEDED=1;}}my$input_VAL_QUOTEMETA=quotemeta($input_VAL);
my$dir_read=$input_DIR ne ''?$input_DIR:&WC::Dir::get_current_dir();
opendir(DIR,$dir_read)or return$result;
my@dir_listing=grep (/^$input_VAL_QUOTEMETA/,grep (!/^\.{1,2}$/,readdir(DIR)));
closedir(DIR);
$result->{'ID'}=1;
my$result_VALUE='';
my$num_founded=scalar@dir_listing;
if($num_founded==1){$result_VALUE=shift@dir_listing;}elsif($num_founded>1){if($in_sort==1){@dir_listing=sort{lc($a)cmp lc($b)}@dir_listing;}elsif($in_sort==-1){@dir_listing=sort{lc($b)cmp lc($a)}@dir_listing;}my$dir_path=$dir_read.(($dir_read!~/([$splitters_RE]|^)$/)?$system_SPLITTER:'');
my$dir_splitter=$input_SPLITTER||$default_SPLITTER||$system_SPLITTER;
foreach(@dir_listing){$_.=$dir_splitter if(-d$dir_path.$_);}$result->{'values'}=\@dir_listing;
$result_VALUE=&get_same_part($result->{'values'});}my$full_path=$input_DIR.$input_SPLITTER.$result_VALUE;
if($num_founded<=1&&-d$full_path&&$full_path!~/[$splitters_RE]$/){if($result_VALUE eq$input_VAL){$full_path.=$input_SPLITTER||$default_SPLITTER;
$IS_FULL_PATH_UPDATE_NEEDED=1;}}my$full_path_fixed=&WC::Dir::check_out($full_path);
if($WC::Autocomplete::IS_OS_WIN32&&$full_path_fixed ne ''&&$full_path_fixed!~/"/&&$in_value=~/^"/){$full_path_fixed='"'.$full_path_fixed.'"';
$IS_FULL_PATH_UPDATE_NEEDED=1;}if(!$IS_FULL_PATH_UPDATE_NEEDED){if($in_value=~/^(.*[$splitters_RE])([^$splitters_RE]{0,})$/){my$left_QM=quotemeta($1);
my$value_QM=quotemeta($2);
if($full_path_fixed!~/^${left_QM}/||$result_VALUE!~/^${value_QM}/){$IS_FULL_PATH_UPDATE_NEEDED=1;}}if(!$IS_FULL_PATH_UPDATE_NEEDED){if($full_path_fixed ne$full_path){$IS_FULL_PATH_UPDATE_NEEDED=1;}}}if($IS_FULL_PATH_UPDATE_NEEDED){if($num_founded>0){$result->{'cmd_left_update'}=$full_path_fixed;}elsif($input_VAL eq ''){$result->{'cmd_left_update'}=$full_path_fixed;}}elsif($result_VALUE ne ''){$result_VALUE=~s/^$input_VAL_QUOTEMETA//;
$result->{'cmd_add'}=$result_VALUE;}return$result;}package WC::Internal;
use strict;
sub pasre_parameters{my($in_value,$in_SETTINGS)=@_;
my$result_HASH={};
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'AS_ARRAY'}=(defined$in_SETTINGS->{'AS_ARRAY'}&&$in_SETTINGS->{'AS_ARRAY'})?1:0;
$in_SETTINGS->{'RETURN_ID'}=(defined$in_SETTINGS->{'RETURN_ID'}&&$in_SETTINGS->{'RETURN_ID'})?1:0;
$in_SETTINGS->{'ESCAPE_OFF'}=(defined$in_SETTINGS->{'ESCAPE_OFF'}&&$in_SETTINGS->{'ESCAPE_OFF'})?1:0;
$in_SETTINGS->{'DISALLOW_SPACES'}=(defined$in_SETTINGS->{'DISALLOW_SPACES'}&&$in_SETTINGS->{'DISALLOW_SPACES'})?1:0;
my@arr_all;
my$re_SPACES=($in_SETTINGS->{'DISALLOW_SPACES'})?'':'[ \n\t]{0,}';
while($in_value=~/(^[ \n\t]{0,})("(\\[^"]|\\"|[^\\"])+"|'(\\[^']|\\'|[^\\'])+'|(\\.|[^ "'\n\t])+)$re_SPACES=$re_SPACES("(\\[^"]|\\"|[^\\"])+"|'(\\[^']|\\'|[^\\'])+'|(\\.|[^ \n\t])+)/||$in_value=~/(^[ \n\t]{0,})("(\\[^"]|\\"|[^\\"])+"|'(\\[^']|\\'|[^\\'])+'|(\\.|[^ "'\n\t])+)[ \n\t]{0,}/){my$name=$2;
my$value=$6;
$in_value=$';
if(!$in_SETTINGS->{'ESCAPE_OFF'}){foreach($name,$value){if(defined$_){if($_=~/^"(.*)"$/){$_=&NL::String::str_unescape($1);}elsif($_=~/^'(.*)'$/){$_=~s/^'//;$_=~s/'$//;$_=~s/\\'/'/g;}}}}if($in_SETTINGS->{'AS_ARRAY'}){push@arr_all,{$name=>$value};}else{$result_HASH->{$name}=$value;}}my$return_id=($in_value=~/^[ \t\r\n]{0,}$/)?1:0;
if($in_SETTINGS->{'AS_ARRAY'}){if($in_SETTINGS->{'RETURN_ID'}){return{'ID'=>$return_id,'DATA'=>\@arr_all};}else{return\@arr_all;}}else{if($in_SETTINGS->{'RETURN_ID'}){return{'ID'=>$return_id,'DATA'=>$result_HASH};}else{return$result_HASH;}}}sub get_unique_id{my$ID=rand;
$ID=~s/^.*\.//;
$ID.='-'.time();
if(defined$NL::AJAX::DATA&&defined$NL::AJAX::DATA->{'DYNAMIC'}&&defined$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}){if(defined$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}){$ID=$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}.'-'.$ID;}}return$ID;}sub check_headers{my($in_value)=@_;
my$result={};
my$header_length=0;
my$NL_length=length("\n");
foreach my $line(split(/\n/,$in_value)){if($line=~/^$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}(.+)/){$header_length+=$NL_length+length($line);
foreach(keys%{$WC::CONST->{'INTERNAL'}->{'HEADERS'}}){my$header_result=&{$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{$_}->{'sub'}}($1);
if(defined$header_result->{'name'}){my$name=$header_result->{'name'};
delete$header_result->{'name'};
$result->{$name}=$header_result;
last;}}}else{if($line eq ''){$header_length+=$NL_length;}$result->{'TEXT'}=substr($in_value,$header_length);
last;}}return$result;}sub check_JS{my($in_ref_value)=@_;
my$result='';
if(defined$in_ref_value&&${$in_ref_value}ne ''){my@JS_CODE;
while(${$in_ref_value}=~/(<script[ \t\n]+type[ \t\n]{0,}=[ \t\n]{0,}(.*)[ \t\n]{0,}>)/i){my$name=$1;
my$lang=defined$2?lc($2):'';
my$is_BAD=0;
${$in_ref_value}=$`;
if(($lang eq ''||index($lang,'javascript')>=0)&&$'=~/<[ \t\n]{0,}\/[ \t\n]{0,}script>/i){push@JS_CODE,$`;}else{${$in_ref_value}.=$name;
$is_BAD=1;}${$in_ref_value}.=$';
if($is_BAD){last;}}foreach(@JS_CODE){$_=~s/^[ \t\n]{0,}<!--//;
$_=~s/(\/\/[ \t]{0,}|)-->[ \t\n]{0,}$//;
if($_ ne ''){$result.="\n" if($result ne ''&&$result!~/\n[ \t]{0,}$/&&$_!~/^[ \t]{0,}\n/);
$result.=$_;}}}return$result;}sub process_output{my($in_ref_value,$in_BACK_STASH)=@_;
my$result={};
if(defined$in_ref_value&&${$in_ref_value}ne ''){my$headers=&check_headers(${$in_ref_value});
if(defined$headers->{'content-type'}&&$headers->{'content-type'}->{'type'}eq 'text/html'){${$in_ref_value}=$headers->{'TEXT'};
my$JS_code=&check_JS($in_ref_value);
$result->{'JS_CODE'}=$JS_code if($JS_code ne '');
$result->{'INPUTS_EDITABLE'}=1;}else{&NL::String::str_HTML_full($in_ref_value);}}if(defined$in_BACK_STASH&&defined$in_BACK_STASH->{'JS_CODE'}&&$in_BACK_STASH->{'JS_CODE'}ne ''){$result->{'JS_CODE'}.="\n" if(defined$result->{'JS_CODE'}&&$result->{'JS_CODE'}ne '');
$result->{'JS_CODE'}.=$in_BACK_STASH->{'JS_CODE'};}return$result;}sub exec_autocompletion{my($in_VALUE)=@_;
my$result={'ID'=>0,'text'=>''};
if(defined$in_VALUE&&$in_VALUE ne ''){my$exec_AC=&autocomplete($in_VALUE,{'EXECUTE'=>1});
if($exec_AC->{'ID'}){if(ref$exec_AC->{'TEXT'}&&defined$exec_AC->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}&&$exec_AC->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}){$result=$exec_AC->{'TEXT'};}else{$result->{'ID'}=1;
$result->{'text'}=$exec_AC->{'TEXT'};
$result->{'BACK_STASH'}=$exec_AC->{'BACK_STASH'};}}}return$result;}sub start_autocompletion{return&autocomplete(defined$_[0]?$_[0]:'');}sub resolve_link{my($in_LINK)=@_;
my$recursion_level=0;
my$item=$in_LINK;
while(!ref$item&&$item=~/^\$\$(.*)\$\$$/){my$hash=$WC::Internal::DATA::ALL;
$item='';
foreach(split/\|/,$1){if(ref$hash&&defined$hash->{$_}){$hash=$hash->{$_};}else{$hash=undef;last;}}$item=$hash if($hash);
$recursion_level++;
$item='' if($recursion_level>=10);}return$item;}sub get_list{my($in_HASH,$in_STRING,$in_SETTINGS)=@_;
$in_STRING='' if(!defined$in_STRING);
my@arr_keys;
if(defined$in_SETTINGS->{'GET_HARD'}&&$in_SETTINGS->{'GET_HARD'}&&$in_STRING ne ''&&defined$in_HASH->{$in_STRING}){if(ref$in_HASH->{$in_STRING}){$in_HASH=$in_HASH->{$in_STRING};
$in_STRING='';}else{my$resolved=&resolve_link($in_HASH->{$in_STRING});
if(ref$resolved){$in_HASH=$resolved;
$in_STRING='';}else{return '';}}}if($in_STRING ne ''){my$in_STRING_QM=quotemeta($in_STRING);
@arr_keys=sort grep (/^$in_STRING_QM/i,keys%{$in_HASH});}else{@arr_keys=sort grep (!/^_/,keys%{$in_HASH});}my$title=defined$in_HASH->{'__doc__'}?$in_HASH->{'__doc__'}:'';
$title=~s/<[^<>]+>//g;
my$result={'TITLE'=>uc($title),'INFO'=>defined$in_HASH->{'__info__'}?$in_HASH->{'__info__'}:'','SUBTITLE'=>'','TEXT'=>''};
my@arr_result;
my$max_length=0;
foreach(@arr_keys){if(ref$in_HASH->{$_}){my$len=length($_);
$max_length=$len if($len>$max_length);
push@arr_result,{'name'=>$_,'doc'=>defined$in_HASH->{$_}->{'__doc__'}?$in_HASH->{$_}->{'__doc__'}:''};}else{my$name=$_;
my$name_alias='';
my$item=$in_HASH->{$name};
if($item=~/^\$\$(.*)\$\$$/){$name_alias=$1;
$name_alias=~s/\|/ /g;
$item=&resolve_link($item);}if(ref$item){my$len=length($name);
$max_length=$len if($len>$max_length);
push@arr_result,{'name'=>$name,'doc'=>"<span class=\"t-red-dark\">-&gt; alias to '$name_alias'</span> ".(defined$item->{'__doc__'}?'('.$item->{'__doc__'}.')':'')};}}}my$space='&nbsp;';
my$spaces_before=$space;
my$spaces_between=$space x 3;
if(scalar@arr_result>0){foreach(@arr_result){$result->{'TEXT'}.="<br />" if($result->{'TEXT'}ne '');
$result->{'TEXT'}.=$spaces_before.'<span class="t-brown">'.$_->{'name'}.'</span>';
if($_->{'doc'}ne ''){my$len=length($_->{'name'});
if($len<$max_length){$result->{'TEXT'}.=$space x($max_length-$len);}$result->{'TEXT'}.='<span class="t-brown-light">'.$spaces_between.$_->{'doc'}.'</span>';}}if($result->{'TEXT'}ne ''){$result->{'TEXT'}=$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result->{'TEXT'};}$result->{'SUBTITLE'}="\n".((defined$in_SETTINGS->{'LIST_TITLE'}&&$in_SETTINGS->{'LIST_TITLE'}ne '')?$in_SETTINGS->{'LIST_TITLE'}:'Please select command:');}return$result;}sub autocomplete{my($in_VALUE,$in_SETTINGS,$in_HASH)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'LIST_TITLE'}='' if(!defined$in_SETTINGS->{'LIST_TITLE'});
$in_SETTINGS->{'EXECUTE'}=0 if(!defined$in_SETTINGS->{'EXECUTE'});
$in_SETTINGS->{'EXECUTE_HARD'}=0 if(!defined$in_SETTINGS->{'EXECUTE_HARD'});
my$PREFIX='#';
my$result={'ID'=>0,'BACK_STASH'=>{},'TITLE'=>'','INFO'=>'','SUBTITLE'=>'','TEXT'=>'','values'=>[],'cmd_add'=>'','cmd_left_update'=>''};
my$is_first_call=0;
if(!defined$in_HASH||!$in_HASH){$in_HASH=$WC::Internal::DATA::ALL;$is_first_call=1;}if($in_VALUE=~/^([^ \t\n\r]+)([ \t\n\r]{0,})(.*)$/){my$re_NO_VALID_CMD=qr/^(_|$)/;
$re_NO_VALID_CMD=qr/^(__|$)/ if($in_SETTINGS->{'EXECUTE'});
my$CMD=defined$1?$1:'';
my$CMD_SPACE=defined$2?$2:'';
my$CMD_PARAMS=defined$3?$3:'';
if($is_first_call&&$CMD eq$PREFIX){if($CMD_SPACE eq ''&&$CMD_PARAMS eq ''){&NL::Utils::hash_update($result,&get_list($WC::Internal::DATA::ALL,'',{'LIST_TITLE'=>$in_SETTINGS->{'LIST_TITLE'}}));
$result->{'ID'}=1;
if($in_SETTINGS->{'EXECUTE'}){my$hash_TMP={};
&NL::Utils::hash_clone($hash_TMP,$result);
$result->{'TEXT'}=$hash_TMP;
$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}=1;}}}elsif($CMD!~$re_NO_VALID_CMD){my$KEY_cmd='';
my@KEYS_good;
my$KEYS_good_TOTAL=0;
my$CMD_QM=quotemeta($CMD);
@KEYS_good=sort grep (/^${CMD_QM}/i,keys%{$in_HASH});
$KEYS_good_TOTAL=scalar@KEYS_good;
if($KEYS_good_TOTAL==1){$KEY_cmd=$KEYS_good[0];}elsif($in_SETTINGS->{'EXECUTE'}&&$in_SETTINGS->{'EXECUTE_HARD'}){if(defined$in_HASH->{$CMD}){@KEYS_good=($CMD);
$KEY_cmd=$CMD;
$KEYS_good_TOTAL=1;}}if($CMD_PARAMS eq ''){if($CMD_SPACE eq ''){if($KEYS_good_TOTAL==1){my$resolved=&resolve_link($in_HASH->{lc($KEY_cmd)});
if(ref$resolved){if($in_SETTINGS->{'EXECUTE'}&&defined$resolved->{'__func__'}){$result->{'TEXT'}=&{$resolved->{'__func__'}}($CMD_PARAMS,$result->{'BACK_STASH'});
$result->{'ID'}=1;}else{my$list=&get_list($resolved,'',{'LIST_TITLE'=>$in_SETTINGS->{'LIST_TITLE'}});
if(ref$list){&NL::Utils::hash_update($result,$list);
$result->{'cmd_add'}=$KEY_cmd.' ';
$result->{'ID'}=1;
if($in_SETTINGS->{'EXECUTE'}){my$hash_TMP={};
&NL::Utils::hash_clone($hash_TMP,$result);
$result->{'TEXT'}=$hash_TMP;
$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}=1;}}}}}elsif($KEYS_good_TOTAL>1){if($in_SETTINGS->{'EXECUTE'}&&defined$in_HASH->{lc($CMD)}){my$resolved=&resolve_link($in_HASH->{lc($CMD)});
if(ref$resolved){if(defined$resolved->{'__func__'}){$result->{'TEXT'}=&{$resolved->{'__func__'}}('',$result->{'BACK_STASH'});
$result->{'ID'}=1;}}}else{my$list=&get_list($in_HASH,$CMD,{'LIST_TITLE'=>$in_SETTINGS->{'LIST_TITLE'}});
if(ref$list){&NL::Utils::hash_update($result,$list);
$result->{'cmd_add'}=&WC::Autocomplete::get_same_part(\@KEYS_good);
$result->{'ID'}=1;
if($in_SETTINGS->{'EXECUTE'}){my$hash_TMP={};
&NL::Utils::hash_clone($hash_TMP,$result);
$result->{'TEXT'}=$hash_TMP;
$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}=1;}}}}if($result->{'cmd_add'}ne ''){$result->{'cmd_add'}=~s/^$CMD_QM//i;}}else{if($KEYS_good_TOTAL==1||defined$in_HASH->{lc($CMD)}){$KEY_cmd=lc($CMD)if($KEYS_good_TOTAL!=1);
my$resolved=&resolve_link($in_HASH->{$KEY_cmd});
if(ref$resolved){if(!defined$resolved->{'__func__'}){my$list=&get_list($resolved,'',{'LIST_TITLE'=>$in_SETTINGS->{'LIST_TITLE'}});
if(ref$list){&NL::Utils::hash_update($result,$list);
$result->{'ID'}=1;
if($in_SETTINGS->{'EXECUTE'}){my$hash_TMP={};
&NL::Utils::hash_clone($hash_TMP,$result);
$result->{'TEXT'}=$hash_TMP;
$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}=1;}}}else{if($in_SETTINGS->{'EXECUTE'}){$result->{'TEXT'}=&{$resolved->{'__func__'}}($CMD_PARAMS,$result->{'BACK_STASH'});
$result->{'ID'}=1;}elsif(defined$resolved->{'__func_auto__'}){my$hash_AC=&{$resolved->{'__func_auto__'}}();
if($hash_AC->{'ID'}){$result=$hash_AC;}}}}}}}else{if($CMD_PARAMS eq '?'&&($KEY_cmd ne ''||defined$in_HASH->{$CMD})&&!$in_SETTINGS->{'EXECUTE'}){$KEY_cmd=$CMD if(defined$in_HASH->{$CMD});
my$list=&get_list($in_HASH,$KEY_cmd,{'GET_HARD'=>1,'LIST_TITLE'=>$in_SETTINGS->{'LIST_TITLE'}});
if(ref$list){&NL::Utils::hash_update($result,$list);
$result->{'ID'}=1;}}elsif($KEY_cmd ne ''||defined$in_HASH->{lc($CMD)}){$KEY_cmd=lc($CMD)if(defined$in_HASH->{lc($CMD)});
my$resolved=&resolve_link($in_HASH->{$KEY_cmd});
if(ref$resolved){if(defined$resolved->{'__func__'}&&$in_SETTINGS->{'EXECUTE'}){$result->{'TEXT'}=&{$resolved->{'__func__'}}($CMD_PARAMS,$result->{'BACK_STASH'});
$result->{'ID'}=1;}elsif(defined$resolved->{'__func_auto__'}){my$hash_AC=&{$resolved->{'__func_auto__'}}($CMD_PARAMS);
if($hash_AC->{'ID'}){$result=$hash_AC;}}else{return&autocomplete($CMD_PARAMS,$in_SETTINGS,$resolved);}}}}}}return$result;}package WC::Internal::DATA;
use strict;
$WC::Internal::DATA::MESSAGES={'_'=>' ','__'=>'  ','___'=>'   ','n_'=>'&nbsp;','n__'=>'&nbsp;&nbsp;','n___'=>'&nbsp;&nbsp;&nbsp;','_AND_PRESS_ENTER'=>' and press "ENTER"','PRESS_ENTER_TO_'=>'Press "ENTER" to ','PRESS_TAB_OR_ENTER_TO_'=>'Press "TAB" or "ENTER" to ','PLEASE_TYPE_FILENAME'=>'Please type <file name>','PLEASE_TYPE_FILENAMES'=>'Please type <file name(s)>','TAB_TO_EASY_'=>'You can use "TAB" key to easy ','TAB_FOR_FILENAME'=>'You can use "TAB" key to easy file name or path choosing'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME_PRESS_ENTER'}=$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME'}.$WC::Internal::DATA::MESSAGES->{'_AND_PRESS_ENTER'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES_PRESS_ENTER'}=$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES'}.$WC::Internal::DATA::MESSAGES->{'_AND_PRESS_ENTER'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME_PRESS_ENTER_USE_TAB'}=$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME_PRESS_ENTER'}."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES_PRESS_ENTER_USE_TAB'}=$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES_PRESS_ENTER'}."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'};
$WC::Internal::DATA::HEADERS={'text/html'=>$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n"};
$WC::Internal::DATA::AC_RESULT={'ID'=>1,'TITLE'=>'','INFO'=>'','SUBTITLE'=>'','TEXT'=>'','values'=>[],'cmd_add'=>'','cmd_left_update'=>''};
$WC::Internal::DATA::ALL={'__doc__'=>'Web Console internal commands','__info__'=>"Type: #[<command>|<command part>] [<sub-command>|<sub-command part>]? [<parameters>]?\n".'Press "TAB" key to commands autocompletion and to see help message about commands.'."\n".'Type "?" after the command and press "TAB" key to see help message about command.'."\n".'Examples:'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'- Starting Web Console File Manger: #file manager<ENTER>'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'- Editing file(s): #edit <file name(s)><ENTER> (choose file name(s) using "TAB")'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'- Downloading file(s): #download <file name(s)><ENTER> (choose file name(s) using "TAB")'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'- Uploading file(s): #upload<ENTER>'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'- View/Edit Web Console settings: #settings<ENTER>'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'- Manage Web Console users: #users<TAB>'."\n",'#about'=>{'__doc__'=>'About Web Console','__info__'=>'Information about Web Console.','authors'=>{'__doc__'=>'Web Console authors','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console authors information.','__func__'=>sub{my$result='<span class="t-lime">Web Console authors:</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Founder and developer:</span> <span class="t-author">Nickolay Kovalev</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- E-mail:</span> <a class="a-brown" href="mailto:Nickolay.Kovalev@nickola.ru">Nickolay.Kovalev@nickola.ru</a><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Resume:</span> <a class="a-brown" href="http://resume.nickola.ru" target="_blank">http://resume.nickola.ru</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Co-Founder:</span> <span class="t-author">Max Kovalev</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- E-mail:</span> <a class="a-brown" href="mailto:Max.Kovalev@maxkovalev.com">Max.Kovalev@maxkovalev.com</a><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Resume:</span> <a class="a-brown" href="http://resume.maxkovalev.com" target="_blank">http://resume.maxkovalev.com</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Your name here?</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- If you would like to develop Web Console, please visit<br/>'.($WC::Internal::DATA::MESSAGES->{'n__'}x 3).'to <a class="a-brown" href="http://forum.web-console.org/go/NEW_DEVELOPER" title="Visit Web Console DEVELOPMENT FORUM" target="_blank">Web Console DEVELOPMENT FORUM</a> for more information.</span>';
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#about'}->{'authors'}->{'__func__'}->();
return$result;}},'version'=>{'__doc__'=>'Web Console version','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console version information.','__func__'=>sub{my$result='<span class="t-lime">Web Console version information:</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console version: <span class="t-red-dark">\''.$WC::CONST->{'VERSION'}->{'NUMBER'}.'\'</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Build date: <span class="t-red-dark">\''.$WC::CONST->{'VERSION'}->{'DATE'}.'\'</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-green">New versions you can download here: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a>';
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#about'}->{'version'}->{'__func__'}->();
return$result;}},'url'=>{'__doc__'=>'Web Console official website and other URLs','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console official website and other URLs.','__func__'=>sub{my$result='<span class="t-lime">Web Console official URLs:</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console official WEBSITE:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" title="Visit to Web Console official WEBSITE" target="_blank">'.$WC::CONST->{'URLS'}->{'SITE'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Usage:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'USAGE'}.'" title="Visit to Web Console Usage" target="_blank">'.$WC::CONST->{'URLS'}->{'USAGE'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console FAQ:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FAQ'}.'" title="Visit to Web Console FAQ" target="_blank">'.$WC::CONST->{'URLS'}->{'FAQ'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console official FORUM:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FORUM'}.'" title="Visit to Web Console official FORUM" target="_blank">http://forum.web-console.org</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Download:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Group services: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'SERVICES'}.'" title="Visit to Web Console Group services" target="_blank">'.$WC::CONST->{'URLS'}->{'SERVICES'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Bug Tracker:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'BUGS'}.'" title="Visit to Web Console Bug Tracker" target="_blank">'.$WC::CONST->{'URLS'}->{'BUGS'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Feature Requests:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'" title="Visit to Web Console Feature Requests" target="_blank">'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'</a>';
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#about'}->{'url'}->{'__func__'}->();
return$result;}},'site'=>'$$#about|url$$','support'=>{'__doc__'=>'Web Console official support information','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console official support information.','__func__'=>sub{my$result='<span class="t-lime">Web Console support information:</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need help with Web Console, please have a look:</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console Usage:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'USAGE'}.'" title="Visit to Web Console Usage" target="_blank">'.$WC::CONST->{'URLS'}->{'USAGE'}.'</a><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console FAQ:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FAQ'}.'" title="Visit to Web Console FAQ" target="_blank">'.$WC::CONST->{'URLS'}->{'FAQ'}.'</a><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console official FORUM:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FORUM'}.'" title="Visit to Web Console official FORUM" target="_blank">http://forum.web-console.org</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need new Web Console version, please have a look:</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console Download:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you think you have found a Web Console bug or you have<br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'an idea about new interest feature, please have a look:</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console Bug Tracker: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'BUGS'}.'" title="Visit to Web Console Bug Tracker" target="_blank">'.$WC::CONST->{'URLS'}->{'BUGS'}.'</a><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console Feature Requests: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'" title="Visit to Web Console Feature Requests" target="_blank">'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need help with your website/server or your have some<br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'interest job for us, please have a look:</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-green">- Web Console Group services: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'SERVICES'}.'" title="Visit to Web Console Group services" target="_blank">'.$WC::CONST->{'URLS'}->{'SERVICES'}.'</a>';
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#about'}->{'support'}->{'__func__'}->();
return$result;}},'services'=>{'__doc__'=>'Web Console Group official services','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see information about Web Console Group official services.','__func__'=>sub{my$result='<span class="t-lime">Web Console Group official services information:</span><br /><span class="t-green">'.$WC::Internal::DATA::MESSAGES->{'n__'}.'<a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'ABOUT_US'}.'" title="Read more information about Web Console Group" target="_blank">Web Console Group</a> provides following services:<br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-blue">- web application development;</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-blue">- server configuration;</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-blue">- technical support;</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-blue">- security analysis;</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-blue">- consulting;</span><br />'.($WC::Internal::DATA::MESSAGES->{'n__'}x 2).'<span class="t-blue">- other services.</span><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'To get more information about it please visit to <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'ABOUT_US'}.'" title="Read more information about Web Console Group" target="_blank">Web Console Group</a><br />'.$WC::Internal::DATA::MESSAGES->{'n__'}.'official services page: <a class="a-brown" href="'.$WC::CONST->{'URLS'}->{'SERVICES'}.'" title="Read more information about Web Console Group services" target="_blank">'.$WC::CONST->{'URLS'}->{'SERVICES'}.'</a></span>';
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#about'}->{'services'}->{'__func__'}->();
return$result;}},'donate'=>{'__doc__'=>'Donate to Web Console project','__info__'=>'Web Console is available for free, and it is sustained by people like you.'."\n".'Please donate today. '.$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console donation information.','__func__'=>sub{my$ID=&WC::Internal::get_unique_id();
my$result='<span class="t-lime">Web Console project donation information:</span><br />'.'<div id="donate-CONTAINER-'.$ID.'"></div>'.'<script type="text/JavaScript"><!--'."\n"."var obj = xGetElementById('donate-CONTAINER-$ID');"."if (obj) obj.innerHTML = WC.Console.HTML.get_DONATION_HTML(1);"."\n".'//--></script>'."\n";
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#about'}->{'donate'}->{'__func__'}->();
return$result;}}},'#services'=>'$$#about|services$$','#support'=>'$$#about|support$$','#help'=>'$$#about|support$$','#open'=>'$$#file|open$$','#o'=>'$$#file|open$$','#show'=>'$$#file|open$$','#edit'=>'$$#file|edit$$','#e'=>'$$#file|edit$$','#download'=>'$$#file|download$$','#d'=>'$$#file|download$$','#get'=>'$$#file|download$$','#upload'=>'$$#file|upload$$','#u'=>'$$#file|upload$$','#send'=>'$$#file|upload$$','#file'=>{},'#settings'=>{},'#config'=>'$$#settings$$','#users'=>{'__doc__'=>'Web Console users management','__info__'=>'Manage Web Console users.','_create'=>{'__doc__'=>'Internal method for user creation (called when form submitted)','__info__'=>'Manual call is not recommended.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result='';
my$prepare_RESULT=$WC::Internal::DATA::ALL->{'#users'}->{'__create_modify_PREPARE'}->($in_CMD);
if(!$prepare_RESULT->{'ID'}){$result=&WC::HTML::get_message("USER CAN'T BE CREATED",'  - '.$prepare_RESULT->{'ERROR'});}else{my$login=defined$prepare_RESULT->{'PARAMETERS'}->{'login'}?$prepare_RESULT->{'PARAMETERS'}->{'login'}:'';
if(&WC::Users::create($prepare_RESULT->{'PARAMETERS'})==1){$result=&WC::HTML::get_message_GOOD("USER '$login' HAS BEEN SUCCESSFULLY CREATED");}else{$result=&WC::HTML::get_message("USER '$login' CAN'T BE CREATED",'  - '.(&WC::Users::get_last_error_TEXT()));}return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;}}},'_remove'=>{'__doc__'=>'Internal method for user removing (called then button at form pressed)','__info__'=>'Manual call is not recommended.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result='';
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD);
if(defined$hash_PARAMS->{'login'}&&$hash_PARAMS->{'login'}ne ''){if(&WC::Users::remove($hash_PARAMS->{'login'})==1){$result=&WC::HTML::get_message_GOOD("USER ('".$hash_PARAMS->{'login'}."') HAS BEEN SUCCESSFULLY REMOVED");}else{$result=&WC::HTML::get_message("USER (".$hash_PARAMS->{'login'}.") CAN'T BE REMOVED",'  - '.(&WC::Users::get_last_error_TEXT()));}}else{$result=&WC::HTML::get_message("USER CAN'T BE REMOVED",'  - Incorrect method call');}return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;}},'_modify'=>{'__doc__'=>'Internal method for user modification (called when form submitted)','__info__'=>'Manual call is not recommended.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result='';
my$login='';
my$prepare_RESULT=$WC::Internal::DATA::ALL->{'#users'}->{'__create_modify_PREPARE'}->($in_CMD);
if($prepare_RESULT->{'ID'}){if(defined$prepare_RESULT->{'PARAMETERS'}->{'real_login'}){$login=$prepare_RESULT->{'PARAMETERS'}->{'real_login'};
delete$prepare_RESULT->{'PARAMETERS'}->{'real_login'};}if($login eq ''){$result->{'ERRORS'}=['"real_login" (REAL USER LOGIN) can\'t be empty'];
$prepare_RESULT->{'ID'}=0;}}if(!$prepare_RESULT->{'ID'}){$result=&WC::HTML::get_message("USER ('$login') INFORMATION CAN'T BE MODIFIED",'  - '.$prepare_RESULT->{'ERROR'});}else{if(&WC::Users::modify($login,$prepare_RESULT->{'PARAMETERS'})==1){$result=&WC::HTML::get_message_GOOD("USER ('$login') INFORMATION HAS BEEN SUCCESSFULLY MODIFIED");}else{$result=&WC::HTML::get_message("USER ('$login') INFORMATION CAN'T BE MODIFIED",'  - '.(&WC::Users::get_last_error_TEXT()));}}return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;}},'__create_modify_PREPARE'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result={'ID'=>1,'ERRORS'=>[],'PARAMETERS'=>{}};
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD);
my$hash_ADDITIONAL={};
if(defined$hash_PARAMS->{'info_additional'}&&$hash_PARAMS->{'info_additional'}!~/^[ \t\r\n]{0,}$/){my$pasre_JSON=&NL::String::JSON_to_HASH($hash_PARAMS->{'info_additional'});
if($pasre_JSON->{'ID'}){$hash_ADDITIONAL=$pasre_JSON->{'HASH'};
delete$hash_PARAMS->{'info_additional'};
&NL::Utils::hash_merge($hash_PARAMS,$hash_ADDITIONAL);}else{$result->{'ID'}=0;
$result->{'ERROR'}='"Additional options" JSON can\'t be parsed, please ensure that entered JSON is correct';}}&NL::Parameter::make_groups($hash_PARAMS,{'additional_'=>{'*'=>'additional','logon_'=>'logon'}});
$result->{'PARAMETERS'}=$hash_PARAMS;
return$result;},'__new_edit_FORM'=>sub{my($in_user_LOGIN,$in_user_INFO)=@_;
my%HTML_HASH=('ACTION'=>'','DATA_LOGIN'=>'','DATA_ADDITIONAL'=>'');
my%HTML_HASH_USER;
my$arr_USER_KEYS_NEEDED=['password','group','e-mail','comment','additional|logon|javascript'];
if(defined$in_user_LOGIN&&defined$in_user_INFO){%HTML_HASH=('ACTION'=>'modify','DATA_LOGIN'=>'','DATA_ADDITIONAL'=>'','TITLE'=>'View/Modify Web Console user information','INFO'=>'Below you can view/edit user information.','MAIN_DIV_ADDON'=>'<tr><td colspan="2" class="area-main s-message">If you need to change user password - please enter it at "New password" and "Confirm new password" fields. '.'If that fields are empty - password will not be changed.</td></tr>','MESSAGE'=>'When you click "Save" button, user modification will be executed as new command. '.'At bottom of the window you will see it, at that command result you will see result of user modification.<br />'.'That View/Edit box will not be closed after modification and you can make new modifications for that user '.'(that is usable when you testing your modification at another browser window).<br />'.'If you don\'t want to modify user information just click "Close" button.','LABEL_PASSWORD'=>'New password:','LABEL_PASSWORD_CONFIRM'=>'Confirm new password:','BUTTON_SUBMIT'=>'Save','JS_CMD_NAME'=>'MODIFYING INFORMATION OF USER','JS_CMD_PREFIX'=>'#users _modify','JS_IS_PASSWORD_NO_EMPTY'=>0);
$HTML_HASH{'DATA_LOGIN'}=$in_user_LOGIN;
my$hash_additional=\%{$in_user_INFO};
%HTML_HASH_USER=%{&NL::Parameter::grab($hash_additional,$arr_USER_KEYS_NEEDED,{'REMOVE_FROM_SOURCE'=>1,'REMOVE_FROM_SOURCE_NODES'=>1,'SET_NOT_FOUND_EMPTY'=>1,'func_ENCODE'=>sub{my($in_val)=@_;
$in_val=&NL::String::str_HTML_value($in_val);
$in_val=~s/\r//g;
return$in_val;}})};
if(scalar keys%{$hash_additional}>0){$HTML_HASH{'DATA_ADDITIONAL'}=&NL::String::str_HTML_value(&NL::String::VAR_to_JSON($hash_additional,{'SPACES'=>1}));}}else{%HTML_HASH=('ACTION'=>'new','DATA_LOGIN'=>'','DATA_ADDITIONAL'=>'','TITLE'=>'Create new Web Console user','INFO'=>'Please fill following fields to create new user.','MAIN_DIV_ADDON'=>'<br />','MESSAGE'=>'When you click "Create" button, new user creation will be executed as new command. '.'At bottom of the window you will see it, at that command result you will see result of user creation.<br />'.'That creation box will not be closed after creation and you can create another new user.','LABEL_PASSWORD'=>'Password:','LABEL_PASSWORD_CONFIRM'=>'Confirm password:','BUTTON_SUBMIT'=>'Create','JS_CMD_NAME'=>'CREATING NEW USER','JS_CMD_PREFIX'=>'#users _create','JS_IS_PASSWORD_NO_EMPTY'=>1);
%HTML_HASH_USER=%{&NL::Parameter::grab({},$arr_USER_KEYS_NEEDED,{'SET_NOT_FOUND_EMPTY'=>1})};}my$hash_groups={''=>' - no group - '};
my$finded_groups=&WC::Users::get_groups_list();
foreach(keys%{$finded_groups}){$hash_groups->{$_}=$_;}$finded_groups->{$HTML_HASH_USER{'group'}}=$HTML_HASH_USER{'group'}if(!defined$finded_groups->{$HTML_HASH_USER{'group'}});
my$groups_options='';
foreach(sort keys%{$hash_groups}){my$value=&NL::String::str_HTML_value($_);
my$name=&NL::String::str_HTML_value($hash_groups->{$_});
my$str_selected=($HTML_HASH_USER{'group'}eq$_)?' selected':'';
$groups_options.='<option value="'.$value.'"'.$str_selected.'>'.$name.'</option>';}my$ID=&WC::Internal::get_unique_id();
my$result_BUTTONS='';
if($HTML_HASH{'ACTION'}eq 'new'){$result_BUTTONS.= <<HTML_EOF;
					<td class="area-button-left"><div id="user-create-button-submit-${ID}" class="div-button w-120">$HTML_HASH{'BUTTON_SUBMIT'}</div></td>
					<td class="area-button-right"><div id="user-create-button-close-${ID}" class="div-button w-120">Close</div></td>
					<td class="area-button-right" colspan="3"><div id="user-create-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
HTML_EOF
}else{$result_BUTTONS.= <<HTML_EOF;
					<td class="area-button-left"><div id="user-create-button-close-${ID}" class="div-button w-120">Close</div></td>
					<td class="area-button-right"><div id="user-create-button-submit-${ID}" class="div-button w-120">$HTML_HASH{'BUTTON_SUBMIT'}</div></td>
					<td class="area-button-right"><div id="user-create-button-remove-${ID}" class="div-button w-150">Remove this user</div></td>
					<td class="area-button-right" colspan="3"><div id="user-create-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
HTML_EOF
}my$result_BOTTOM='<table class="grid" id="wc-user-BUTTONS-'.$ID.'" style="width: 765px">';
$result_BOTTOM.='<tr><td class="s-comment">'.$HTML_HASH{'MESSAGE'}.'</td></tr>';
$result_BOTTOM.='<tr><td><table class="grid"><tr>';
$result_BOTTOM.=$result_BUTTONS;
$result_BOTTOM.='</tr></table></td></tr></table>';
my$result_DIVS= <<HTML_EOF;
	<div id="user-create-DIV-MAIN-${ID}">
		<form id="user-create-form-MAIN-${ID}" action="" onsubmit="return false" target="_blank">
		<input type="hidden" id="_h_user_login-${ID}" name="h_user_login-${ID}" value="$HTML_HASH{'DATA_LOGIN'}" />
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">$HTML_HASH{'INFO'}</td></tr>
			<tr>
				<td class="area-left-short">Login:</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="text" id="_user_login-${ID}" name="user_login-${ID}" value="$HTML_HASH{'DATA_LOGIN'}" /></td></tr>
			<tr>
				<td class="area-left-short">E-mail:</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="text" id="_user_e-mail-${ID}" name="user_e-mail-${ID}" value="$HTML_HASH_USER{'e-mail'}" /></td></tr>
			<tr>
				<td class="area-left-short"><span>$HTML_HASH{'LABEL_PASSWORD'}</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="password" id="_user_password-${ID}" name="user_password-${ID}" /></td></tr>
			<tr>
				<td class="area-left-short"><span>$HTML_HASH{'LABEL_PASSWORD_CONFIRM'}</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="password" id="_user_password-${ID}_c" name="user_password-${ID}_c" /></td></tr>
			<tr>
				<td class="area-left-short">Group:<br /><span class="s-note">(groups not used now)</span></td>
				<td class="area-right-long"><select class="w-200" id="_user_group-${ID}" name="user_group-${ID}">$groups_options</select></td></tr>
			<tr>
				<td class="area-left-short">Comment:</td>
				<td class="area-right-long"><textarea style="width: 400px; height: 60px" id="_user_comment-${ID}" name="user_comment-${ID}">$HTML_HASH_USER{'comment'}</textarea></td></tr>
			$HTML_HASH{'MAIN_DIV_ADDON'}
		</table></form>
	</div>
	<div id="user-create-DIV-STARTUPJS-${ID}" style="display: none">
		<form id="user-create-form-STARTUPJS-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Startup JavaScript <span class="s-note s-info" style="cursor: help" title="When user logons to Web Console - that JavaScript will be executed">(will be executed after user logon)</span>:
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 180px" id="_user_info_startup_JAVASCRIPT-${ID}" name="user_info_startup_JAVASCRIPT-${ID}">$HTML_HASH_USER{'additional'}{'logon'}{'javascript'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="user-create-button-startup_JAVASCRIPT-EXEC-${ID}" class="div-button w-270">Execute this JavaScript now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
	<div id="user-create-DIV-ADDITIONAL-${ID}" style="display: none">
		<form id="user-create-form-ADDITIONAL-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Additional user options <span class="s-note s-info" style="cursor: help" title="JavaScript Object Notation">(at JSON format)</span>:
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 180px" id="_user_info_additional-${ID}" name="user_info_additional-${ID}">$HTML_HASH{'DATA_ADDITIONAL'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="user-create-button-additional-CHECK-${ID}" class="div-button w-270">Check validity of this JSON now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
HTML_EOF
foreach($result_DIVS,$result_BOTTOM){$_=~s/([\\'])/\\$1/g;
$_=~s/\n/\\n/g;}my$result_HTML= <<HTML_EOF;
	<div id="user-create-CONTAINER-${ID}"></div>
	<script type="text/JavaScript"><!--
		WC.UI.tab_set('user-create-CONTAINER-${ID}', '$HTML_HASH{'TITLE'}', '${result_DIVS}', {
			'ID': 'user-create-tab-${ID}',
			'MENU': {
				'User information': { 'id': 'user-create-DIV-MAIN-${ID}', 'active': 1 },
				'User startup JavaScript': { 'id': 'user-create-DIV-STARTUPJS-${ID}' },
				'Additional options': { 'id': 'user-create-DIV-ADDITIONAL-${ID}' }
			},
			'MENU_DIV_SIZE_SAME': 1,
			'BOTTOM': '${result_BOTTOM}'
		});
		NL.UI.div_button_register('div-button', 'user-create-button-submit-$ID', function () {
			var hash_DATA = NL.Form.check_fields({
				'_h_user_login-${ID}': { 'name_at_hash': 'real_login', 'name': 'ORIGINAL USER LOGIN (internal)', 'needed': 0 },
				'_user_login-${ID}': { 'name_at_hash': 'login', 'name': 'Login', 'needed': 1,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'User information'); }
				},
				'_user_e-mail-${ID}': { 'name_at_hash': 'e-mail', 'name': 'E-mail', 'needed': 1,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'User information'); },
					'func_CHECK': NL.Form.FUNC_CHECK_email
				},
				'_user_password-${ID}': { 'name_at_hash': 'password', 'name': '$HTML_HASH{'LABEL_PASSWORD'}', 'needed': $HTML_HASH{'JS_IS_PASSWORD_NO_EMPTY'}, 'confirm': 1,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'User information'); },
					'func_ENCODE': function(in_value) {
					if (NL.Crypt.sha1_vm_test()) return [1, NL.Crypt.sha1_hex(in_value)];
					else { alert('Java Virtual Machine works incorrectly'); return [0, '']; }
					}
				},
				'_user_group-${ID}': { 'name_at_hash': 'group', 'name': 'Group', 'needed': 0 },
				'_user_comment-${ID}': { 'name_at_hash': 'comment', 'name': 'Comment', 'needed': 0 },
				'_user_info_startup_JAVASCRIPT-${ID}': { 'name_at_hash': 'additional_logon_javascript', 'name': 'User startup JavaScript', 'needed': 0,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'Startup JavaScript'); },
					'func_ENCODE': function(in_value) { return [1, in_value]; }
				},
				'_user_info_additional-${ID}': { 'name_at_hash': 'info_additional', 'name': 'Additional options', 'needed': 0,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'Additional options'); },
					'func_ENCODE': function(in_value) {
						var is_OK = 1;
						if (in_value && !in_value.match(/^[ \\t\\r\\n]{0,}\$/)) {
							try { eval ('('+in_value+')'); }
							catch (e) {
								is_OK = 0;
								alert("JSON at field \\"Additional options\\" is incorrect, please fix it:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
							}
							if (is_OK) return [1, in_value];
							else return [-1, ''];
						}
						else return [1, ''];
					}
				}
			}, 1);
			if (hash_DATA) {
				// OK entered DATA is valid, executing command
				WC.Console.Exec.CMD_INTERNAL("$HTML_HASH{'JS_CMD_NAME'} '"+hash_DATA['login']+"'", '$HTML_HASH{'JS_CMD_PREFIX'}', hash_DATA);
			}
		});
		NL.UI.div_button_register('div-button', 'user-create-button-close-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('user-create-tab-$ID'); });
		NL.UI.div_button_register('div-button-270', 'user-create-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('user-create-tab-$ID'); });
		NL.UI.div_button_register('div-button-270', 'user-create-button-startup_JAVASCRIPT-EXEC-$ID', function () {
			var obj_JS = xGetElementById('_user_info_startup_JAVASCRIPT-${ID}');
			if (obj_JS && obj_JS.value && !obj_JS.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
				try { eval (obj_JS.value); }
				catch (e) {
					alert("JavaScript code execution error:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
				}
			}
			else alert("JavaScript code is empty, please enter it or leave blank");
		});
		NL.UI.div_button_register('div-button-270', 'user-create-button-additional-CHECK-${ID}', function () {
			var obj = xGetElementById('_user_info_additional-${ID}');
			if (obj && obj.value && !obj.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
				var is_OK = 1;
				try { eval ('('+obj.value+')'); }
				catch (e) {
					is_OK = 0;
					alert("JSON is incorrect:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
				}
				if (is_OK) alert("JSON is valid");
			}
			else alert("JSON code is empty, please enter it or leave blank");
		});
HTML_EOF
if($HTML_HASH{'ACTION'}ne 'new'){$result_HTML.= <<HTML_EOF;
		NL.UI.div_button_register('div-button-180', 'user-create-button-remove-${ID}', function () {
			var obj = xGetElementById('_h_user_login-${ID}');
			if (obj && obj.value) {
				if (confirm('Are you sure, user "'+obj.value+'" will be removed?')) {
					// Removing user
					WC.Console.Exec.CMD_INTERNAL("REMOVING USER '"+obj.value+"'", '#users _remove', { 'login': obj.value });
				}
			}
			else alert("ORIGINAL USER LOGIN (internal) can't be found");
		});
HTML_EOF
}$result_HTML.= <<HTML_EOF;
	//--></script>
HTML_EOF
return$result_HTML;},'add'=>{'__doc__'=>'Add/create new user','__info__'=>'Create new Web Console user.'."\n".$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'open Web Console user creation form.','__func__'=>sub{return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$WC::Internal::DATA::ALL->{'#users'}->{'__new_edit_FORM'}->();},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#users'}->{'add'}->{'__func__'}->();
return$result;}},'create'=>'$$#users|add$$','new'=>'$$#users|add$$','show'=>{'__doc__'=>'Show registred users list / view or edit user information / remove user','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console registred users list.','__func_auto__'=>sub{my($in_CMD,$in_BACK_STASH,$in_IS_EXECUTION)=@_;
$in_CMD='' if(!defined$in_CMD);
$in_BACK_STASH={}if(!defined$in_BACK_STASH);
my$result=\%{$WC::Internal::DATA::AC_RESULT};
my$hash_USERS_AC={'__doc__'=>$WC::Internal::DATA::ALL->{'#users'}->{'show'}->{'__doc__'},'__info__'=>'Below you can see Web Console registred users list.'."\n".'You can select user using autocomplete feature by "TAB" key.'."\n".'To view/edit full user information please select user and press "ENTER".'."\n".'  Examples:'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'  - View registred users list which login begins from "a": #users ... a<TAB>'."\n".$WC::Internal::DATA::MESSAGES->{'__'}.'  - View/edit full information of user "admin": #users ... admin<ENTER>'."\n"};
my$hash_USERS=&WC::Users::get_users_list();
my$user_info='';
foreach my $user(keys%{$hash_USERS}){$user_info='';
my$arr_info=[{'group'=>'Group: '}];
foreach my $item(@{$arr_info}){foreach(keys%{$item}){$user_info.=', ' if($user_info ne '');
$user_info.='<span class="t-red-dark">'.$item->{$_}."</span>'";
$user_info.=&NL::String::str_HTML_full($hash_USERS->{$user}->{$_})if(defined$hash_USERS->{$user}->{$_});
$user_info.="'";}}if(defined$hash_USERS->{$user}->{'comment'}&&$hash_USERS->{$user}->{'comment'}ne ''){$user_info.=', ' if($user_info ne '');
$user_info.='<span class="t-red-dark">comment:</span> \'';
$user_info.=&NL::String::str_HTML_value(&NL::String::get_left(&NL::String::str_to_line($hash_USERS->{$user}->{'comment'}),30,1));
$user_info.="'";}$hash_USERS_AC->{$user}={'__doc__'=>$user_info,'__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'view/edit full user information.','__func__'=>sub{return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$WC::Internal::DATA::ALL->{'#users'}->{'__new_edit_FORM'}->($user,$hash_USERS->{$user});},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$hash_USERS_AC->{$user}->{'__func__'}->();
return$result;}};}my$hash_SETTINGS={'LIST_TITLE'=>'Registred users list:'};
if(defined$in_IS_EXECUTION&&$in_IS_EXECUTION){$hash_SETTINGS->{'EXECUTE'}=1;
$hash_SETTINGS->{'EXECUTE_HARD'}=1;}if($in_CMD eq ''){&NL::Utils::hash_update($result,&WC::Internal::get_list($hash_USERS_AC,'',$hash_SETTINGS));
return$result;}else{my$hash_AC=&WC::Internal::autocomplete($in_CMD,$hash_SETTINGS,$hash_USERS_AC);
if(!$hash_AC->{'ID'}){$in_CMD=~s/[ \n\t].*$//;
$hash_AC->{'ID'}=1;
$hash_AC->{'TITLE'}=uc($WC::Internal::DATA::ALL->{'#users'}->{'show'}->{'__doc__'});
$hash_AC->{'SUBTITLE'}='  - No user "'.$in_CMD.'" found, please enter valid user login';}return$hash_AC;}},'__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result=\%{$WC::Internal::DATA::AC_RESULT};
&NL::Utils::hash_update($result,$WC::Internal::DATA::ALL->{'#users'}->{'show'}->{'__func_auto__'}->($in_CMD,{},1));
$result->{'SHOW_AS_TAB_RESULT'}=1;
return$result;}},'view'=>'$$#users|show$$','edit'=>'$$#users|show$$','modify'=>'$$#users|show$$','list'=>'$$#users|show$$','delete'=>'$$#users|show$$','remove'=>'$$#users|show$$'},'#logout'=>{'__doc__'=>'Logout from Web Console','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_ENTER_TO_'}.'logout from Web Console.','__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TITLE'}=uc($WC::Internal::DATA::ALL->{'#logout'}->{'__doc__'});
$result->{'INFO'}=$WC::Internal::DATA::ALL->{'#logout'}->{'__info__'};
return$result;},'__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$REDIRECT_URL=$WC::c->{'APP_SETTINGS'}->{'file_name'}.'?logon_rand='.(time());
my$result="<div class=\"t-lime\">LOGGING OUT FROM WEB CONSOLE... [<a href=\"$REDIRECT_URL\" class=\"a-brown\">CLICK TO LOGOUT</a>]</div>";
$result.= <<HTML_EOF;
	<script type="text/JavaScript"><!--
		window.location='$REDIRECT_URL';
	//--></script>
HTML_EOF
return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;}},'#exit'=>'$$#logout$$','#close'=>'$$#logout$$','#quit'=>'$$#logout$$','#chmod'=>'$$#file|chmod$$','#manager'=>'$$#file|manager$$'};
package WC::Internal::Data::Settings;
use strict;
$WC::Internal::Data::Settings::ENCODINGS_LIST=['UTF-8','af_ZA.ISO8859-1','af_ZA.ISO8859-15','af_ZA.UTF-8','am_ET.UTF-8','be_BY.CP1131','be_BY.CP1251','be_BY.ISO8859-5','be_BY.UTF-8','bg_BG.CP1251','bg_BG.UTF-8','ca_ES.ISO8859-1','ca_ES.ISO8859-15','ca_ES.UTF-8','cs_CZ.ISO8859-2','cs_CZ.UTF-8','da_DK.ISO8859-1','da_DK.ISO8859-15','da_DK.UTF-8','de_AT.ISO8859-1','de_AT.ISO8859-15','de_AT.UTF-8','de_CH.ISO8859-1','de_CH.ISO8859-15','de_CH.UTF-8','de_DE.ISO8859-1','de_DE.ISO8859-15','de_DE.UTF-8','el_GR.ISO8859-7','el_GR.UTF-8','en_AU.ISO8859-1','en_AU.ISO8859-15','en_AU.US-ASCII','en_AU.UTF-8','en_CA.ISO8859-1','en_CA.ISO8859-15','en_CA.US-ASCII','en_CA.UTF-8','en_GB.ISO8859-1','en_GB.ISO8859-15','en_GB.US-ASCII','en_GB.UTF-8','en_IE.UTF-8','en_NZ.ISO8859-1','en_NZ.ISO8859-15','en_NZ.US-ASCII','en_NZ.UTF-8','en_US.ISO8859-1','en_US.ISO8859-15','en_US.US-ASCII','en_US.UTF-8','es_ES.ISO8859-1','es_ES.ISO8859-15','es_ES.UTF-8','et_EE.ISO8859-15','et_EE.UTF-8','fi_FI.ISO8859-1','fi_FI.ISO8859-15','fi_FI.UTF-8','fr_BE.ISO8859-1','fr_BE.ISO8859-15','fr_BE.UTF-8','fr_CA.ISO8859-1','fr_CA.ISO8859-15','fr_CA.UTF-8','fr_CH.ISO8859-1','fr_CH.ISO8859-15','fr_CH.UTF-8','fr_FR.ISO8859-1','fr_FR.ISO8859-15','fr_FR.UTF-8','he_IL.UTF-8','hi_IN.ISCII-DEV','hr_HR.ISO8859-2','hr_HR.UTF-8','hu_HU.ISO8859-2','hu_HU.UTF-8','hy_AM.ARMSCII-8','hy_AM.UTF-8','is_IS.ISO8859-1','is_IS.ISO8859-15','is_IS.UTF-8','it_CH.ISO8859-1','it_CH.ISO8859-15','it_CH.UTF-8','it_IT.ISO8859-1','it_IT.ISO8859-15','it_IT.UTF-8','ja_JP.SJIS','ja_JP.UTF-8','ja_JP.eucJP','kk_KZ.PT154','kk_KZ.UTF-8','ko_KR.CP949','ko_KR.UTF-8','ko_KR.eucKR','la_LN.ISO8859-1','la_LN.ISO8859-15','la_LN.ISO8859-2','la_LN.ISO8859-4','la_LN.US-ASCII','lt_LT.ISO8859-13','lt_LT.ISO8859-4','lt_LT.UTF-8','nl_BE.ISO8859-1','nl_BE.ISO8859-15','nl_BE.UTF-8','nl_NL.ISO8859-1','nl_NL.ISO8859-15','nl_NL.UTF-8','no_NO.ISO8859-1','no_NO.ISO8859-15','no_NO.UTF-8','pl_PL.ISO8859-2','pl_PL.UTF-8','pt_BR.ISO8859-1','pt_BR.UTF-8','pt_PT.ISO8859-1','pt_PT.ISO8859-15','pt_PT.UTF-8','ro_RO.ISO8859-2','ro_RO.UTF-8','ru_RU.CP1251','ru_RU.CP866','ru_RU.ISO8859-5','ru_RU.KOI8-R','ru_RU.UTF-8','sk_SK.ISO8859-2','sk_SK.UTF-8','sl_SI.ISO8859-2','sl_SI.UTF-8','sr_YU.ISO8859-2','sr_YU.ISO8859-5','sr_YU.UTF-8','sv_SE.ISO8859-1','sv_SE.ISO8859-15','sv_SE.UTF-8','tr_TR.ISO8859-9','tr_TR.UTF-8','uk_UA.ISO8859-5','uk_UA.KOI8-U','uk_UA.UTF-8','zh_CN.GB18030','zh_CN.GB2312','zh_CN.GBK','zh_CN.UTF-8','zh_CN.eucCN','zh_HK.Big5HKSCS','zh_HK.UTF-8','zh_TW.Big5','zh_TW.UTF-8'];
$WC::Internal::Data::MESSAGES->{'PARAMETER_GET_SET'}='To get current value - just press "ENTER", to set parameter - type value and press "ENTER".';
$WC::Internal::Data::MESSAGES->{'PARAMETER_EXAMPLE_'}='Example:'."\n";
$WC::Internal::Data::MESSAGES->{'PARAMETER_GET_SET_EXAMPLE_'}=$WC::Internal::Data::MESSAGES->{'PARAMETER_GET_SET'}."\n".$WC::Internal::Data::MESSAGES->{'PARAMETER_EXAMPLE_'};
$WC::Internal::DATA::ALL->{'#settings'}={'__doc__'=>'View/edit Web Console configuration','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'view/edit Web Console configuration.','_save_form'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result='';
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD);
my$hash_ADDITIONAL={};
if(defined$hash_PARAMS->{'info_additional'}&&$hash_PARAMS->{'info_additional'}!~/^[ \t\r\n]{0,}$/){my$pasre_JSON=&NL::String::JSON_to_HASH($hash_PARAMS->{'info_additional'});
if($pasre_JSON->{'ID'}){$hash_ADDITIONAL=$pasre_JSON->{'HASH'};
delete$hash_PARAMS->{'info_additional'};
&NL::Utils::hash_merge($hash_PARAMS,$hash_ADDITIONAL);}else{$result=&WC::HTML::get_message("CONFIGURATION CAN'T BE SAVED",'  - "Additional options" JSON can\'t be parsed, please ensure that entered JSON is correct');}}if($result eq ''){&NL::Parameter::make_groups($hash_PARAMS,{'dir_'=>'directorys','encoding_'=>'encodings','logon_'=>'logon','style_'=>{'*'=>'styles','console_'=>{'*'=>'console','font_'=>'font'}},'startup_'=>'startup','uploading_'=>'uploading'});
my$check_RESULT=&NL::Parameter::check($hash_PARAMS,{'directorys|temp'=>{'name'=>'Directory/Temp','needed'=>0,'if_undefined_or_empty_set'=>$WC::c->{'config'}->{'directorys'}->{'temp'},'func_CHECK'=>\&NL::Parameter::FUNC_CHECK_directory},'directorys|work'=>{'name'=>'Directory/Work','needed'=>0,'if_undefined_or_empty_set'=>$WC::c->{'config'}->{'directorys'}->{'work'},'func_CHECK'=>\&NL::Parameter::FUNC_CHECK_directory},'encodings|server_console'=>{'name'=>'Encoding/Server console','needed'=>0,'if_undefined_or_empty_set'=>''},'encodings|server_system'=>{'name'=>'Encoding/Server system','needed'=>0,'if_undefined_or_empty_set'=>''},'encodings|editor_text'=>{'name'=>'Encoding/Text editor','needed'=>0,'if_undefined_or_empty_set'=>''},'encodings|file_download'=>{'name'=>'Encoding/Downloading (file name)','needed'=>0,'if_undefined_or_empty_set'=>''},'logon|show_welcome'=>{'name'=>'Logon/Show welcome message on logon','needed'=>0,'if_undefined_or_empty_set'=>0},'logon|show_warnings'=>{'name'=>'Logon/Show warnings','needed'=>0,'if_undefined_or_empty_set'=>0},'logon|javascript'=>{'name'=>'Global startup JavaScript','needed'=>0,'if_undefined_or_empty_set'=>''},'styles|console|font|color'=>{'name'=>'Console font styles/Color','needed'=>0,'if_undefined_or_empty_set'=>$WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'color'}},'styles|console|font|size'=>{'name'=>'Console font styles/Size','needed'=>0,'if_undefined_or_empty_set'=>$WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'size'}},'styles|console|font|family'=>{'name'=>'Console font styles/Family','needed'=>0,'if_undefined_or_empty_set'=>$WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'family'}}});
if(!$check_RESULT->{'ID'}){$result=&WC::HTML::get_message("CONFIGURATION CAN'T BE SAVED",'  - '.$check_RESULT->{'ERROR_MESSAGE'});}else{if(!&WC::Config::Main::save($hash_PARAMS)){$result=&WC::HTML::get_message("CONFIGURATION CAN'T BE SAVED",'  - '.(&WC::Config::Main::get_last_error_TEXT()));}else{$result=&WC::HTML::get_message_GOOD("CONFIGURATION HAS BEEN SUCCESSFULLY SAVED");}}}return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;},'_settings_FORM'=>sub{my$ID=&WC::Internal::get_unique_id();
my%HTML_HASH=('TITLE'=>'Web Console Configuration','INFO'=>'Main Web Console parameters &mdash; directorys, files, flags...','MESSAGE'=>'When you click "Save" button, configuration saving will be executed as new command. '.'At bottom of the window you will see it, at that command result you will see result of configuration saving.<br />'.'That configuration box will not be closed after configuration saving and you can change something again '.'(that is usable when you testing your modifications at another browser window).<br />'.'If you don\'t want to modify configuration just click "Close" button.','DATA_ADDITIONAL'=>'');
my$CONFIG_DATA={};
&NL::Parameter::clone($CONFIG_DATA,$WC::c->{'config'});
my%HTML_HASH_CONFIG=%{&NL::Parameter::grab($CONFIG_DATA,['directorys|work','directorys|temp','directorys|home','directorys|data','directorys|configs','directorys|plugins','directorys|plugins_configs','files|config','files|users','files|.HTACCESS','logon|javascript','logon|show_welcome','logon|show_warnings','encodings|internal','encodings|server_console','encodings|server_system','encodings|editor_text','encodings|file_download','styles|console|font|family','styles|console|font|size','styles|console|font|color','uploading|limit'],{'REMOVE_FROM_SOURCE'=>1,'REMOVE_FROM_SOURCE_NODES'=>1,'SET_NOT_FOUND_EMPTY'=>1,'func_ENCODE'=>sub{my($in_val)=@_;
$in_val=&NL::String::str_HTML_value($in_val);
$in_val=~s/\r//g;
return$in_val;}})};
$HTML_HASH{'MAIN_FLAG_SHOW_WELCOME'}=(defined$HTML_HASH_CONFIG{'logon'}{'show_welcome'}&&$HTML_HASH_CONFIG{'logon'}{'show_welcome'})?' checked="checked"':'';
$HTML_HASH{'MAIN_FLAG_SHOW_WARNINGS'}=(defined$HTML_HASH_CONFIG{'logon'}{'show_warnings'}&&$HTML_HASH_CONFIG{'logon'}{'show_warnings'})?' checked="checked"':'';
&NL::Parameter::remove($CONFIG_DATA,['directorys_splitter']);
if(scalar keys%{$CONFIG_DATA}>0){$HTML_HASH{'DATA_ADDITIONAL'}=&NL::String::str_HTML_value(&NL::String::VAR_to_JSON($CONFIG_DATA,{'SPACES'=>1}));}my$result_ENCODINGS='';
foreach(@{$WC::Internal::Data::Settings::ENCODINGS_LIST}){$result_ENCODINGS.=", " if($result_ENCODINGS  ne '');
$result_ENCODINGS.='<a class="link" href="#" onclick="var v = NL.Form.value_get(\'_encodings_ACTIVE_INPUT-'.$ID.'\'); if (v) NL.Form.value_set(v, \''.$_.'\', 1); else this.blur(); return false" title="Click to paste at active (or last active) encodings input">'.$_.'</a>';}my$HTML_ENCODE_PM_MESSAGE='';
if(!$WC::Encode::ENCODE_ON){my$error_HTML=$WC::Encode::ENCODE_ERROR;
$error_HTML=&NL::String::fix_width($error_HTML,70);
&NL::String::str_HTML_value(\$error_HTML);
$error_HTML=~s/\n/<br \/>/g;
$HTML_ENCODE_PM_MESSAGE= <<HTML_EOF;
			<tr><td class="area-main s-warning" style="padding-top: 9px; font-weight: bold;" colspan="2">*** WARNING:</td></tr>
			<tr>
				<td class="area-tabbed s-warning" colspan="2">
					ENCODINGS CONVERSION WILL BE DISABLED.<br />
					Unable to load 'Encode.pm' Perl module, that module is needed for encodings conversion.<br />
					You can download that Perl module from CPAN: <a class="link-warning" href="http://search.cpan.org/~dankogai/Encode/Encode.pm" target="_blank">http://search.cpan.org/~dankogai/Encode/Encode.pm</a>
					<br />
					<span class="s-warning" style="font-weight: bold;">Additional information:</span><br />
					<div class="s-warning" style="margin-top: 0; height: 32px; overflow: auto">$error_HTML</div>
				</td>
			</tr>
HTML_EOF
}my$HTML_CGI_PM_MESSAGE='';
&WC::Upload::_set_NL_INIT();
my$init_UPLOAD=&NL::AJAX::Upload::init($WC::Upload::NL_INIT);
if(!$init_UPLOAD->{'ID'}){my$error_HTML=$init_UPLOAD->{'ERROR_MSG'};
$error_HTML=&NL::String::fix_width($error_HTML,70);
&NL::String::str_HTML_value(\$error_HTML);
$error_HTML=~s/\n/<br \/>/g;
$HTML_CGI_PM_MESSAGE= <<HTML_EOF;
			<tr><td class="area-main s-warning" style="padding-top: 9px; font-weight: bold;" colspan="2">*** WARNING:</td></tr>
			<tr>
				<td class="area-tabbed s-warning" colspan="2">
					UPLOADING WILL BE DISABLED.<br />
					Unable to load 'CGI.pm' Perl module, that module is needed for uploading.<br />
					You can download that Perl module from CPAN: <a class="link-warning" href="http://search.cpan.org/~lds/CGI.pm/CGI.pm" target="_blank">http://search.cpan.org/~lds/CGI.pm/CGI.pm</a>
					<br /><br />
					<span class="s-warning" style="font-weight: bold;">Additional information:</span><br />
					<div class="s-warning" style="margin-top: 3px; height: 100px; overflow: auto">$error_HTML</div>
				</td>
			</tr>
HTML_EOF
}my$result_DIVS= <<HTML_EOF;
	<div id="wc-settings-DIV-MAIN-$ID">
		<form id="wc-settings-form-MAIN-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">$HTML_HASH{'INFO'}</td></tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Directorys:</span></td></tr>
			<tr>
				<td class="area-left-short"><span>Work:</span></td>
				<td class="area-right-long"><input class="in-text w-600" type="text" id="_main_dir_work-${ID}" name="main_dir_work-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'work'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span>Temp:</span></td>
				<td class="area-right-long"><input class="in-text w-600" type="text" id="_main_dir_temp-${ID}" name="main_dir_temp-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'temp'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Home:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_home-${ID}" name="main_dir_home-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'home'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Data:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_data-${ID}" name="main_dir_data-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'data'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Configs:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_configs-${ID}" name="main_dir_configs-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'configs'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Plugins:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_plugins-${ID}" name="main_dir_plugins-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'plugins'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Plugins configs:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_plugins_configs-${ID}" name="main_dir_plugins_configs-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'plugins_configs'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Files:</span></td></tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Config:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_file_config-${ID}" name="main_file_config-${ID}" value="$HTML_HASH_CONFIG{'files'}{'config'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Users DB:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_file_users_db-${ID}" name="main_file_users_db-${ID}" value="$HTML_HASH_CONFIG{'files'}{'users'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">.HTACCESS:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_file_htaccess-${ID}" name="main_file_htaccess-${ID}" value="$HTML_HASH_CONFIG{'files'}{'.HTACCESS'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Logon flags:</span></td></tr>
			<tr><td class="area-tabbed" colspan="2">
				<table class="grid">
				<tr>
					<td class="area-left-short" style="vertical-align: top"><input class="in-checkbox" type="checkbox" id="_main_flag_logon_show_welcome-$ID" name="main_flag_logon_show_welcome-$ID"$HTML_HASH{'MAIN_FLAG_SHOW_WELCOME'} value="1" /></td>
					<td class="area-right-long"><label class="s-message" for="_main_flag_logon_show_welcome-$ID">Show welcome message on logon<br /><span class="s-note s-message" style="cursor: help" title="When any user logons to Web Console - informational message will be printed">(informational message about Web Console usage and useful commands)</span></label></td>
				</tr>
				<tr>
					<td class="area-left-short" style="vertical-align: top"><input class="in-checkbox" type="checkbox" id="_main_flag_logon_show_warnings-$ID" name="main_flag_logon_show_warnings-$ID"$HTML_HASH{'MAIN_FLAG_SHOW_WARNINGS'} value="1" /></td>
					<td class="area-right-long"><label class="s-message" for="_main_flag_logon_show_warnings-$ID">Show warnings<br /><span class="s-note s-message" style="cursor: help" title="When any user logons to Web Console - warnings message will be printed">(informational message about Web Console warnings)</span></label></td>
				</tr>
				</table>
			</td></tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-ENCODINGS-$ID" style="display: none">
		<form id="wc-settings-form-ENCODINGS-${ID}" action="" onsubmit="return false" target="_blank">
		<input type="hidden" id="_encodings_ACTIVE_INPUT-${ID}" name="encodings_ACTIVE_INPUT-${ID}" value="" />
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">Web Console encodings settings.</td></tr>
			<tr>
				<td style="width: 10%; padding-right: 20px;">
					<table class="grid" style="width: 100%;">
						<tr>
							<td class="area-left-short"><span>Server console:</span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_server_console-${ID}" name="encoding_server_console-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_server_console-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'server_console'}" /></td>
						</tr>
						<tr>
							<td class="area-left-short"><span>Server system:</span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_server_system-${ID}" name="encoding_server_system-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_server_system-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'server_system'}" /></td>
						</tr>
						<tr>
							<td class="area-left-short"><span class="disabled" title="Element is readonly">Web Console:<br /><span class="s-note disabled">(internal)</span></td>
							<td class="area-right-long"><input class="in-text w-200 disabled" type="text" id="_main_file_config-${ID}" name="main_file_config-${ID}" value="$HTML_HASH_CONFIG{'encodings'}{'internal'}" title="Element is readonly" readonly /></td>
						</tr>
					</table>
				</td>
				<td style="width: 90%; vertical-align: top; text-align: left;">
					<table class="grid" style="width: 100%">
						<tr>
							<td class="area-left-short"><span>Text editor:</span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_editor_text-${ID}" name="encoding_editor_text-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_editor_text-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'editor_text'}" /></td>
						</tr>
						<tr>
							<td class="area-left-short"><span>Downloading:<br /><span class="s-note">(filename)</span></span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_file_download-${ID}" name="encoding_file_download-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_file_download-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'file_download'}" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td class="area-main s-group-name" style="padding-top: 9px" colspan="2"><span>Short manual:</span></td></tr>
			<tr>
				<td class="area-tabbed s-message" colspan="2">
					<span class="s-name">"Server console encoding"</span> is a encoding of server shell commands execution output (like 'ls', 'dir', ...).<br />
					<span class="s-name">"Server system encoding"</span> is a encoding of server internal commands (programming commands) output<br />
					(like getting listing of the directory using internal Perl function).<br />
					<span class="s-name">"Text editor encoding"</span> is a encoding for text files editor ('<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set('#file edit'); return false" title="Click to paste at command input">#file edit</a>'), if that field empty, then for text<br />files editor the <span class="s-name">"Server system encoding"</span> will be used.<br />
					<span class="s-name">"Downloading (filename)"</span> is a encoding for downloaded file names.<br />
					<div style="padding: 0; margin: 12px 0;">
						<span class="s-warning">Detailed information about setting Web Console encodings you can read <a class="link-warning" href="http://www.web-console.org/faq/#ENCODINGS_HOWTO" title="Read detailed information about setting Web Console encodings" target="_blank">here</a>.</span>
					</div>
HTML_EOF
if($HTML_ENCODE_PM_MESSAGE eq ''){$result_DIVS.= <<HTML_EOF;
					Common encodings list:<br />
					<span class="s-warning s-note">(click at encoding to paste it at active (or last active) encodings input)</span>
					<div class="s-link" style="margin-top: 3px; padding: 3px 4px; border: solid 1px #333300; height: 81px; overflow: auto">${result_ENCODINGS}</div>
HTML_EOF
}$result_DIVS.= <<HTML_EOF;
				</td>
			</tr>
			$HTML_ENCODE_PM_MESSAGE
		</table></form>
	</div>
	<div id="wc-settings-DIV-STYLE-$ID" style="display: none">
		<form id="wc-settings-form-STYLE-${ID}" action="" onsubmit="return false" target="_blank">
		<input type="hidden" id="_style_ACTIVE_INPUT-${ID}" name="style_ACTIVE_INPUT-${ID}" value="" />
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">Web Console style settings.</td></tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Console font styles:</span></td></tr>
			<tr>
				<td class="area-left-short"><span>Family:</span></td>
				<td class="area-right-long"><input class="in-text w-600" type="text" id="_style_console_font_family-${ID}" name="style_console_font_family-${ID}" onclick="NL.Form.value_set('_style_ACTIVE_INPUT-${ID}', '_style_console_font_family-${ID}')" value="$HTML_HASH_CONFIG{'styles'}{'console'}{'font'}{'family'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span>Color:</span></td>
				<td class="area-right-long"><input class="in-text w-200" type="text" id="_style_console_font_color-${ID}" name="style_console_font_color-${ID}" onclick="NL.Form.value_set('_style_ACTIVE_INPUT-${ID}', '_style_console_font_color-${ID}')" value="$HTML_HASH_CONFIG{'styles'}{'console'}{'font'}{'color'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span>Size:</span></td>
				<td class="area-right-long"><input class="in-text w-200" type="text" id="_style_console_font_size-${ID}" name="style_console_font_size-${ID}" onclick="NL.Form.value_set('_style_ACTIVE_INPUT-${ID}', '_style_console_font_size-${ID}')" value="$HTML_HASH_CONFIG{'styles'}{'console'}{'font'}{'size'}" /></td>
			</tr>
			<tr><td class="area-main s-group-name" style="padding-top: 9px" colspan="2"><span>Short manual:</span></td></tr>
			<tr>
				<td class="area-tabbed s-message" colspan="2">
					At the field <span class="s-name">"Console font styles / Family"</span> you can set console font family at the CSS 'font-family' format.<br />
					At the field <span class="s-name">"Console font styles / Color"</span> you can set console font color at the CSS 'color' format.<br />
					At the field <span class="s-name">"Console font styles / Size"</span> you can set console font size at the CSS 'font-size' format.<br />
					<br /><span class="s-warning">Values at these fields should be set according the CSS font specification ('font-family', 'font-size', 'color', ...).<br />
					Detailed information about setting Web Console style you can read <a class="link-warning" href="http://www.web-console.org/faq/#STYLE_HOWTO" title="Read detailed information about setting Web Console style" target="_blank">here</a>.</span><br />
					<br />Examples:<br />
					<span class="s-warning s-note">(click at value to paste it at active (or last active) style input)</span><br />
					- To set only one font family: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, 'courier', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">courier</a>"</span><br />
					- To set first available font family: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, 'fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif</a>"</span><br />
					- To set white font color: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, 'white', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">white</a>"</span> or <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '#ffffff', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">#ffffff</a>"</span><br />
					- To restore default font color: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '#bbbbbb', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">#bbbbbb</a>"</span><br />
					- To set font size at points or pixels: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '10pt', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">10pt</a>"</span> or <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '14px', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">14px</a>"</span>
				</td>
			</tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-STARTUPJS-${ID}" style="display: none">
		<form id="wc-settings-form-STARTUPJS-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Web Console global startup JavaScript:<br />
				<span class="s-note s-info" style="cursor: help" title="When any user logons to Web Console - that JavaScript will be executed">(will be executed after any user logon and before user personal JavaScript execution if it's defined)</span>
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 290px" id="_logon_JAVASCRIPT-${ID}" name="logon_JAVASCRIPT-${ID}">$HTML_HASH_CONFIG{'logon'}{'javascript'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="startupjs_JAVASCRIPT-EXEC-${ID}" class="div-button w-270">Execute this JavaScript now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-ADDITIONAL-${ID}" style="display: none">
		<form id="wc-settings-form-ADDITIONAL-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Additional configuration options <span class="s-note s-info" style="cursor: help" title="JavaScript Object Notation">(at JSON format)</span>:
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 290px" id="_info_additional-${ID}" name="info_additional-${ID}">$HTML_HASH{'DATA_ADDITIONAL'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="wc-settings-button-additional-CHECK-${ID}" class="div-button w-270">Check validity of this JSON now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-OTHER-${ID}" style="display: none">
		<form id="wc-settings-form-OTHER-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">Web Console uploading settings.</td></tr>
			<tr>
				<td class="area-left-short"><span>Uploading limit (in MB):</span></td>
				<td class="area-right-long"><input class="in-text w-100" type="text" id="_other_uploading_limit-${ID}" name="other_uploading_limit-${ID}" value="$HTML_HASH_CONFIG{'uploading'}{'limit'}" /></td>
			</tr>
			<tr><td class="area-main s-group-name" style="padding-top: 9px" colspan="2"><span>Short manual:</span></td></tr>
			<tr>
				<td class="area-tabbed s-message" colspan="2">
					At the field <span class="s-name">"Uploading limit"</span> you can set maximum size (in MB) for uploading file(s).<br />
					Uploading will not start if uploading size is greater than the specified maximum size.
				</td>
			</tr>
			$HTML_CGI_PM_MESSAGE
		</table></form>
	</div>
HTML_EOF
my$result_BOTTOM='<table class="grid" id="wc-settings-BUTTONS-'.$ID.'" style="width: 765px">';
$result_BOTTOM.='<tr><td class="s-comment">'.$HTML_HASH{'MESSAGE'}.'</td></tr>';
$result_BOTTOM.='<tr><td><table class="grid"><tr>';
$result_BOTTOM.= <<HTML_EOF;
				<td class="area-button-left"><div id="wc-settings-button-submit-${ID}" class="div-button w-120">Save</div></td>
				<td class="area-button-right"><div id="wc-settings-button-close-${ID}" class="div-button w-120">Close</div></td>
				<td class="area-button-right" colspan="3"><div id="wc-settings-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
HTML_EOF
$result_BOTTOM.='</tr></table></td></tr></table>';
foreach($result_DIVS,$result_BOTTOM){$_=~s/([\\'])/\\$1/g;
$_=~s/\n/\\n/g;}my$result_HTML= <<HTML_EOF;
<div id="wc-settings-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	WC.UI.tab_set('wc-settings-CONTAINER-${ID}', '$HTML_HASH{'TITLE'}', '${result_DIVS}', {
		'ID': 'wc-settings-tab-${ID}',
		'MENU': {
			'Main settings': { 'id': 'wc-settings-DIV-MAIN-${ID}', 'active': 1 },
			'Style': { 'id': 'wc-settings-DIV-STYLE-${ID}' },
			'Encodings': { 'id': 'wc-settings-DIV-ENCODINGS-${ID}' },
			'Uploading': { 'id': 'wc-settings-DIV-OTHER-${ID}' },
			'Global startup JavaScript': { 'id': 'wc-settings-DIV-STARTUPJS-${ID}' },
			'Additional options': { 'id': 'wc-settings-DIV-ADDITIONAL-${ID}' }
		},
		'MENU_DIV_SIZE_SAME': 1,
		'BOTTOM': '${result_BOTTOM}'
	});
	NL.UI.div_button_register('div-button', 'wc-settings-button-close-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('wc-settings-tab-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-settings-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('wc-settings-tab-${ID}'); });
	NL.UI.div_button_register('div-button', 'startupjs_JAVASCRIPT-EXEC-$ID', function () {
		var obj_JS = xGetElementById('_logon_JAVASCRIPT-${ID}');
		if (obj_JS && obj_JS.value && !obj_JS.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
			try { eval (obj_JS.value); }
			catch (e) {
				alert("JavaScript code execution error:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
			}
		}
		else alert("JavaScript code is empty, please enter it or leave blank");
	});
	NL.UI.div_button_register('div-button-270', 'wc-settings-button-additional-CHECK-${ID}', function () {
		var obj = xGetElementById('_info_additional-${ID}');
		if (obj && obj.value && !obj.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
			var is_OK = 1;
			try { eval ('('+obj.value+')'); }
			catch (e) {
				is_OK = 0;
				alert("JSON is incorrect:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
			}
			if (is_OK) alert("JSON is valid");
		}
		else alert("JSON code is empty, please enter it or leave blank");
	});
	NL.UI.div_button_register('div-button', 'wc-settings-button-submit-${ID}', function () {
		var hash_DATA = NL.Form.check_fields({
			// Main settings
			'_main_dir_work-${ID}': { 'name_at_hash': 'dir_work', 'name': 'Directory/Work', 'needed': 0 },
			'_main_dir_temp-${ID}': { 'name_at_hash': 'dir_temp', 'name': 'Directory/Temp', 'needed': 0 },
			// Main settings :: flags
			'_main_flag_logon_show_welcome-$ID': { 'type': 'checkbox', 'name_at_hash': 'logon_show_welcome', 'name': 'Flag/Show welcome message on logon', 'needed': 0 },
			'_main_flag_logon_show_warnings-$ID': { 'type': 'checkbox', 'name_at_hash': 'logon_show_warnings', 'name': 'Flag/Show warnings', 'needed': 0 },
			// Encodings
			'_encoding_server_console-${ID}': { 'name_at_hash': 'encoding_server_console', 'name': 'Encoding/Server console', 'needed': 0 },
			'_encoding_server_system-${ID}': { 'name_at_hash': 'encoding_server_system', 'name': 'Encoding/Server system', 'needed': 0 },
			'_encoding_editor_text-${ID}': { 'name_at_hash': 'encoding_editor_text', 'name': 'Encoding/Text editor', 'needed': 0 },
			'_encoding_file_download-${ID}': { 'name_at_hash': 'encoding_file_download', 'name': 'Encoding/Downloading (file name)', 'needed': 0 },
			// Style
			'_style_console_font_family-${ID}': { 'name_at_hash': 'style_console_font_family', 'name': 'Console font styles/Family', 'needed': 0 },
			'_style_console_font_size-${ID}': { 'name_at_hash': 'style_console_font_size', 'name': 'Console font styles/Size', 'needed': 0 },
			'_style_console_font_color-${ID}': { 'name_at_hash': 'style_console_font_color', 'name': 'Console font styles/Color', 'needed': 0 },
			// Other
			'_other_uploading_limit-${ID}': { 'name_at_hash': 'uploading_limit', 'name': 'Uploading limit', 'needed': 0 },
			// Global startup JavaScript
			'_logon_JAVASCRIPT-${ID}': { 'name_at_hash': 'logon_javascript', 'name': 'Web Console startup JavaScript', 'needed': 0 },
			'_info_additional-${ID}': { 'name_at_hash': 'info_additional', 'name': 'Additional options', 'needed': 0,
				'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('wc-settings-tab-${ID}', 'Additional options'); },
				'func_ENCODE': function(in_value) {
					var is_OK = 1;
					if (in_value && !in_value.match(/^[ \\t\\r\\n]{0,}\$/)) {
						try { eval ('('+in_value+')'); }
						catch (e) {
							is_OK = 0;
							alert("JSON at field \\"Additional options\\" is incorrect, please fix it:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
						}
						if (is_OK) return [1, in_value];
						else return [-1, ''];
					}
					else return [1, ''];
				}
			}
		}, 1);
		if (hash_DATA) {
			// OK entered DATA is valid, executing command
			//NL.Debug.dump_alert(hash_DATA);
			WC.Console.Exec.CMD_INTERNAL("SAVING SETTINGS", '#settings _save_form', hash_DATA);
		}
	});
//--></script>
HTML_EOF
return$result_HTML;},'__func__'=>sub{my($in_CMD)=@_;
if(defined$in_CMD&&$in_CMD=~/^_save_form[ \t\n\r]+/i){return$WC::Internal::DATA::ALL->{'#settings'}->{'_save_form'}->($');}else{return$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$WC::Internal::DATA::ALL->{'#settings'}->{'_settings_FORM'}->();}},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#settings'}->{'__func__'}->();
return$result;}};
package WC::Internal::Data::File;
use strict;
$WC::Internal::Data::File::MESSAGES={'TYPE_FILE_DIRECTORY_TAB'=>'Please type <file name(s)>/<directory name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}};
$WC::Internal::DATA::ALL->{'#file'}={'__doc__'=>'File operations (download, upload, edit, ...)','__info__'=>'Common file operatons.','_edit_reload'=>{'__doc__'=>'Internal method for file reloading (called when form button "Reload file" clicked)','__info__'=>'Manual call is not recommended.','__func__'=>sub{my($in_CMD,$in_BACK_STASH)=@_;
$in_CMD='' if(!defined$in_CMD);
$in_BACK_STASH={}if(!defined$in_BACK_STASH);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD);
my$check_RESULT=&NL::Parameter::check($hash_PARAMS,{'js_id_DATA'=>{'name'=>'ID of TEXTAREA','needed'=>1},'dir'=>{'name'=>'Directory path','needed'=>1,'can_be_empty'=>1},'file_name'=>{'name'=>'Filename','needed'=>1},'js_ID'=>{'name'=>'Element ID','needed'=>1}});
my$result='';
if(!$check_RESULT->{'ID'}){my$error=&NL::String::str_JS_value(&WC::HTML::get_message("FILE CAN'T BE RELOADED",'  - '.$check_RESULT->{'ERROR_MESSAGE'}));
my$file=(defined$hash_PARAMS->{'file_name'}&&$hash_PARAMS->{'file_name'}ne '')?&NL::String::str_JS_value(&WC::HTML::get_short_value($hash_PARAMS->{'file_name'})):&NL::String::str_JS_value(&WC::HTML::get_short_value('_UNKNOWN_'));
$result=''.'<script type="text/JavaScript"><!--'."\n".((defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne '')?' WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');':'').'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> RELOADING FILE '.$file.'</span>\', \''.$error.'\');'."\n".'//--></script>';}else{my$is_OK=0;
my$message='';
my$dir=&WC::Dir::check_in($hash_PARAMS->{'dir'});
if($dir ne ''&&!&WC::Dir::change_dir($dir)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("FILE CAN'T BE RELOADED",'  - Incorrect TARGET DIRECTORY specified'));}else{my$hash_READ=&edit_READ($hash_PARAMS->{'file_name'});
if(!$hash_READ->{'ID'}){$message=&NL::String::str_JS_value(&WC::HTML::get_message("FILE CAN'T BE RELOADED",'&nbsp;&nbsp;-&nbsp;'.$hash_READ->{'ERROR'},{'ENCODE_TO_HTML'=>0}));}else{$is_OK=1;
my$ID=&WC::Internal::get_unique_id();
my$HTML_message_good="FILE HAS BEEN SUCCESSFULLY RELOADED";
my$HTML_message_bad="FILE CAN'T BE RELOADED, TEXTAREA OBJECT IS NOT FOUND";
foreach($hash_READ->{'FILE_DATA'},$HTML_message_good,$HTML_message_bad){&NL::String::str_JS_value(\$_);}$in_BACK_STASH->{'JS_CODE'}=''.'	var obj = xGetElementById(\''.$hash_PARAMS->{'js_id_DATA'}.'\'); '.'	var is_obj_found = 0; '.'	if (obj) { obj.value = "'.$hash_READ->{'FILE_DATA'}.'"; is_obj_found = 1; } '.'	var obj_RESULT = xGetElementById(\'wc-file-edit-RELOAD-RESULT-'.$ID.'\'); '.'	if (is_obj_found) WC.Console.HTML.add_time_message(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'['.$HTML_message_good.']\', { \'TIME\': 5 }); '.'	else WC.Console.HTML.add_time_message(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'['.$HTML_message_bad.']\', { \'TIME\': 5 }); ';}}my$file=&NL::String::str_JS_value(&WC::HTML::get_short_value($hash_PARAMS->{'file_name'}));
$result='<script type="text/JavaScript"><!--'."\n".'WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\'); ';
if($is_OK){$result.=$message;}else{$result.='var obj = xGetElementById(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\'); if (obj) obj.innerHTML = \'\'; ';
$result.='WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> RELOADING FILE '.$file.'</span>\', \''.$message.'\');';}$result.="\n".'//--></script>';}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}},'edit'=>{'__doc__'=>'Edit/View file','__info__'=>'Please type: <file name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n"."  Examples:\n"."    - #file edit file.txt\n"."    - #file edit file1.txt file2.txt",'__func__'=>sub{my($in_CMD,$in_BACK_STASH,$in_SETTINGS)=@_;
$in_CMD='' if(!defined$in_CMD);
$in_BACK_STASH={}if(!defined$in_BACK_STASH);
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'IS_OPEN'}=0 if(!defined$in_SETTINGS->{'IS_OPEN'});
my$result='';
my$hash_PARAMS;
my@arr_files;
if($in_SETTINGS->{'IS_OPEN'}){@arr_files=@{$in_SETTINGS->{'ARR_FILES'}};
$hash_PARAMS={'ID'=>1,'DATA'=>[]};}else{$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD,{'RETURN_ID'=>1,'AS_ARRAY'=>1,'ESCAPE_OFF'=>0,'DISALLOW_SPACES'=>1});}if(!$hash_PARAMS->{'ID'}){$result=&WC::HTML::get_message("FILE(S) CAN'T BE EDITED",'  - Incorect input, please specify file(s) correctly');}else{my$dir='';
my$dir_found=0;
foreach my $line(@{$hash_PARAMS->{'DATA'}}){foreach(keys%{$line}){if($_ ne ''){if(!$dir_found&&$_=~/^['"]{0,}-dir['"]{0,}$/i&&defined$line->{$_}){$dir_found=1;
$dir=$line->{$_};}else{my$path=$_;
if(defined$line->{$_}){$path.='='.$line->{$_};}push@arr_files,$path;}}}}my$is_OK=1;
if($dir_found){$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$result=&WC::HTML::get_message("FILE(S) CAN'T BE EDITED",'  - Incorrect TARGET DIRECTORY specified');
$is_OK=0;}elsif(!&WC::Dir::change_dir($dir)){$result=&WC::HTML::get_message("FILE(S) CAN'T BE EDITED",'&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});
$is_OK=0;}}if($is_OK){if(scalar@arr_files<=0){$result=&WC::HTML::get_message("FILE(S) CAN'T BE EDITED",'  - Incorect input, no file(s) specified');}else{my$ID=&WC::Internal::get_unique_id();
my$MAX_FILES=5;
my$num_ok=0;
my$num_total=0;
$result='';
my$result_BAD='';
my$result_GOOD_HTML_JS_VALUE='';
my$result_GOOD_JS='';
my@result_GOOD_ARR;
my$hash_files_OPENED={};
foreach(@arr_files){$num_total++;
my$path=&WC::Dir::check_in($_);
if($num_ok>=$MAX_FILES){&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path);
$result_BAD.='<div class="t-blue">&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path).' does not opened: <span class="t-red-dark">maximum opened files at the same time is '.$MAX_FILES.'</span></div>';}else{if(defined$hash_files_OPENED->{$path}){&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path);
$result_BAD.='<div class="t-blue">&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path).' already opened</div>';}else{my$hash_FORM=&edit_FORM($path,{'DIV_HIDDEN'=>($num_ok>0)?1:0,'ID'=>$ID});
if(!$hash_FORM->{'ID'}){$result_BAD.=$hash_FORM->{'HTML'};}else{$hash_files_OPENED->{$path}=1;
$num_ok++;
push@result_GOOD_ARR,{'path'=>$path,'DIV_ID'=>$hash_FORM->{'DIV_ID'}};
$result_GOOD_HTML_JS_VALUE.=$hash_FORM->{'HTML_JS_VALUE'};
$result_GOOD_JS.="\n" if($result_GOOD_JS ne '');
$result_GOOD_JS.=$hash_FORM->{'JS'};}}}}my$is_JS_needed=0;
if($num_total>1){$result="<div class=\"t-lime\">OPENED '$num_ok' OF '$num_total':</div>";
if($num_total>$num_ok){$result.="<div class=\"t-green\">&nbsp;&nbsp;Not opened:</div>".$result_BAD;}if($num_ok>0){$result.="<div class=\"t-green\">&nbsp;&nbsp;Below you can see file(s) that has been successfully opened:</div>\n";$is_JS_needed=1;}}else{if($num_ok>0){$is_JS_needed=1;}else{$result="<div class=\"t-lime\">FILE CAN'T BE OPENED:</div>".$result_BAD;}}if($is_JS_needed){my$result_MENU='';
foreach(@result_GOOD_ARR){if($result_MENU eq ''){$result_MENU.="'".&NL::String::str_HTML_value(&NL::String::get_right($_->{'path'},22,1))."': { 'id': '".$_->{'DIV_ID'}."', 'active': 1 }";}else{$result_MENU.=", '".&NL::String::str_HTML_value(&NL::String::get_right($_->{'path'},22,1))."': { 'id': '".$_->{'DIV_ID'}."' }";}}$result.= <<HTML_EOF;
<div id="wc-file-edit-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	// Getting width and height
	var t_h = xClientHeight(); t_h -= 210; if (t_h < 100) t_h = 100;
	var t_w = xClientWidth(); t_w -= 90;
	if (NL.Browser.Detect.isIE) { if (t_w < 870) t_w = 870; }
	else { if (t_w < 925) t_w = 925; }
	var font_style_small = '';
	if (t_w < 950) font_style_small = 'style="font-size: 12px" ';
	WC.UI.tab_set('wc-file-edit-CONTAINER-${ID}', 'Edit/View file(s)', '$result_GOOD_HTML_JS_VALUE', {
		'ID': 'wc-file-edit-tab-${ID}',
		'MENU': { $result_MENU },
		'MENU_DIV_SIZE_SAME': 1,
		'BOTTOM': ''
	});
//--></script>
$result_GOOD_JS
HTML_EOF
}}}}return((!$in_SETTINGS->{'IS_OPEN'})?$WC::Internal::DATA::HEADERS->{'text/html'}:'').$result;}},'chmod'=>{'__doc__'=>'CHMOD file(s)/directory(s)','__info__'=>'Please type: <VALUE> <file name(s)>/<directory name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n"."  Examples:\n"."    - #file chmod 777 file.txt some_directory\n"."    - #file chmod 755 file1.pl file2.pl\n"."    - #file chmod 660 .htaccess",'__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD,{'RETURN_ID'=>1,'AS_ARRAY'=>1,'ESCAPE_OFF'=>0,'DISALLOW_SPACES'=>1});
my$result='';
if(!$hash_PARAMS->{'ID'}){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed",'  - Incorect input, please specify chmod value and file(s)/directory(s) correctly');}else{my$value='';
my$dir='';
my$dir_found=0;
my@arr_files;
foreach my $line(@{$hash_PARAMS->{'DATA'}}){foreach(keys%{$line}){if($_ ne ''){if(!$dir_found&&$_=~/^['"]{0,}-dir['"]{0,}$/i&&defined$line->{$_}){$dir_found=1;
$dir=$line->{$_};}elsif($value eq ''){$value=$_;
$value=~s/^'//;$value=~s/'$//;
$value=~s/^"//;$value=~s/"$//;}else{my$path=$_;
if(defined$line->{$_}){$path.='='.$line->{$_};}push@arr_files,$path;}}}}my$is_OK=1;
if($dir_found){$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed",'  - Incorrect TARGET DIRECTORY specified');
$is_OK=0;}elsif(!&WC::Dir::change_dir($dir)){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed",'&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});
$is_OK=0;}}if($is_OK){if($value!~/^\d{3}$/){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed",'&nbsp;&nbsp;- Incorect input, CHMOD value "<span class="t-link">'.&NL::String::str_HTML_value($value).'</span>" is incorrect (values examples: <span class="t-link">777</span>, <span class="t-link">755</span>, <span class="t-link">660</span>)<br />'."&nbsp;&nbsp;&nbsp;&nbsp;Examples:<br />"."&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #file chmod 777 file.txt<br />"."&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #file chmod 755 file.pl file2.pl file3.php<br />"."&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #file chmod 660 .htaccess",{'ENCODE_TO_HTML'=>0});}elsif(scalar@arr_files<=0){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed",'  - Incorect input, no file(s)/directory(s) specified');}else{my$html_chmodded='';
my$num_chmodded=0;
my$num_total=0;
foreach(@arr_files){my$path=&WC::Dir::check_in($_);
my$path_encoded=$path;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_encoded);
$num_total++;
$html_chmodded.='<br />' if($html_chmodded ne '');
my$type='';
if(!-e$path){$html_chmodded.='&nbsp;&nbsp;-&nbsp;No file/directory '.&WC::HTML::get_short_value($path_encoded).' found';}elsif(-f$path){$type='File';}else{$type='Directory';}if($type ne ''){if(chmod(oct($value),$path)>0){$html_chmodded.='&nbsp;&nbsp;-&nbsp;'.$type.' '.&WC::HTML::get_short_value($path_encoded).' has been successfully CHMOD\'ed';$num_chmodded++;}else{$html_chmodded.='&nbsp;&nbsp;-&nbsp;'.$type.' '.&WC::HTML::get_short_value($path_encoded).' can not be CHMOD\'ed'.(($!ne '')?'<br /><span class="t-green-light">&nbsp;&nbsp;&nbsp;&nbsp;'.$!.'</span>':'');}}}$result=&WC::HTML::get_message("CHMOD'ing '<span class=\"t-link\">$value</span>' RESULTS (CHMOD'ed '$num_chmodded' OF '$num_total')",$html_chmodded,{'ENCODE_TO_HTML'=>0});}}}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}},'remove'=>{'__doc__'=>'Remove file(s)/directory(s)','__info__'=>'Please type: <file name(s)>/<directory name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n"."  Examples:\n"."    - #file remove file.txt some_directory\n"."    - #file remove file1.pl file.tar.gz",'__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD,{'RETURN_ID'=>1,'AS_ARRAY'=>1,'ESCAPE_OFF'=>0,'DISALLOW_SPACES'=>1});
my$result='';
if(!$hash_PARAMS->{'ID'}){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED",'  - Incorect input, please specify file(s)/directory(s) correctly');}else{my$dir='';
my$dir_found=0;
my@arr_files;
foreach my $line(@{$hash_PARAMS->{'DATA'}}){foreach(keys%{$line}){if($_ ne ''){if(!$dir_found&&$_=~/^['"]{0,}-dir['"]{0,}$/i&&defined$line->{$_}){$dir_found=1;
$dir=$line->{$_};}else{my$path=$_;
if(defined$line->{$_}){$path.='='.$line->{$_};}push@arr_files,$path;}}}}my$is_OK=1;
if($dir_found){$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED",'  - Incorrect TARGET DIRECTORY specified');
$is_OK=0;}elsif(!&WC::Dir::change_dir($dir)){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED",'&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});
$is_OK=0;}}if($is_OK){if(scalar@arr_files<=0){$result=&WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED",'  - Incorect input, no file(s)/directory(s) specified');}else{my$html_removed='';
my$num_removed=0;
my$num_total=0;
foreach(@arr_files){my$path=&WC::Dir::check_in($_);
my$path_encoded=$path;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_encoded);
$num_total++;
$html_removed.='<br />' if($html_removed ne '');
if(!-e$path){$html_removed.='&nbsp;&nbsp;-&nbsp;No file/directory '.&WC::HTML::get_short_value($path_encoded).' found';}elsif(-f$path){if(unlink($path)>0){$html_removed.='&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_encoded).' has been successfully removed';$num_removed++;}else{$html_removed.='&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_encoded).' can not be removed'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':'');}}else{my$hash_REMOVE=&manager_DIR_remove($path);
if($hash_REMOVE->{'ID'}){$html_removed.='&nbsp;&nbsp;-&nbsp;Directory '.&WC::HTML::get_short_value($path_encoded).' has been successfully removed';$num_removed++;}else{$html_removed.='&nbsp;&nbsp;-&nbsp;File/directory '.&WC::HTML::get_short_value($path_encoded).' can not be removed:<br /><span class="t-green-light">&nbsp;&nbsp;&nbsp;&nbsp;'.$hash_REMOVE->{'ERROR'}.'</span>';}}}$result=&WC::HTML::get_message("REMOVING RESULTS (REMOVED '$num_removed' OF '$num_total')",$html_removed,{'ENCODE_TO_HTML'=>0});}}}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}},'manager'=>{'__doc__'=>'File manager (files/directories manipulation)','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'open Web Console File Manager.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result='';
my$in_DIR=&WC::Dir::check_in($in_CMD);
if($in_DIR ne ''){if(!&WC::Dir::change_dir($in_DIR)){my$error='Directory '.&WC::HTML::get_short_value($in_DIR).' is not accessible'.(($!ne '')?': '.$!:'');
$error.='<br />&nbsp;&nbsp;&nbsp;&nbsp;Please choose another directory';
$result=&WC::HTML::get_message("FILE MANAGER CAN'T BE STARTED",'&nbsp;&nbsp;-&nbsp;'.$error,{'ENCODE_TO_HTML'=>0});
return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}}&WC::Dir::update_current_dir();
my$dir_current=&WC::Dir::get_current_dir();
my$ID=&WC::Internal::get_unique_id();
my$hash_LIST=&manager_DIR_listing($dir_current,{'MAKE_HTML_AS_JS_STRING'=>1,'JS_ID'=>$ID});
if(!$hash_LIST->{'ID'}){$result=&WC::HTML::get_message("FILE MANAGER CAN'T BE STARTED",'&nbsp;&nbsp;-&nbsp;'.$hash_LIST->{'ERROR'},{'ENCODE_TO_HTML'=>0});}else{my$HTML_message_PATH=&NL::String::str_JS_value(&NL::String::str_HTML_value($dir_current));
my$HTML_message_PATH_TO_PROMPT=$HTML_message_PATH;
my$HTML_message_MAIN=''.'<form id="wc-file-manager-form-'.$ID.'" action="" onsubmit="return false" target="_blank">'.'<input type="hidden" id="_wc-file-manager-REGEX-'.$ID.'" name="wc-file-manager-REGEX-'.$ID.'" value="" />'.'<input type="hidden" id="_wc-file-manager-PATH-'.$ID.'" name="wc-file-manager-PATH-'.$ID.'" value="'.$HTML_message_PATH.'" />'.'<input type="hidden" id="_wc-file-manager-ID-'.$ID.'" name="wc-file-manager-ID-'.$ID.'" value="'.$ID.'" />'.'<table class="grid" style="width: 100%">'.'	<tr><td>'.'		<table class="grid" style="width: 100%"><tr>'.'			<td class="wc-ui-fm-path-text">Path:</td>'.'			<td class="wc-ui-fm-path-input"\'+ff_style+\'><input class="in-text" style="border: 1px solid #6a7070; \'+path_input_WIDTH+\'" type="text" id="_wc_file_manager_PATH_IN-'.$ID.'" name="wc_file_manager_PATH_IN-'.$ID.'" value="'.$HTML_message_PATH.'" onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /></td>'.'			<td class="wc-ui-fm-path-button-GO"><div id="wc-file-manager-button-GO-'.$ID.'" class="div-button" style="width: 20px" title="Go to path">GO</div></td>'.'			<td class="wc-ui-fm-path-button-UP"><div id="wc-file-manager-button-UP-'.$ID.'" class="div-button" style="width: 20px" title="Go upper">UP</div></td>'.'		</tr></table>'.'	</td></tr>'.'<tr><td>'.'	<table class="grid" style="width: 100%"><tr>'.'		<td class="wc-ui-fm-info-left">Files/directories total: <span id="_wc_file_manager_TOTAL-'.$ID.'">'.$hash_LIST->{'TOTAL'}.'</span>, selected: <span id="_wc_file_manager_SELECTED-'.$ID.'">0</span></td>'.'		<td class="wc-ui-fm-info-right"><span class="span-message" id="_wc_file_manager_STATUS-MESSAGE-'.$ID.'">&nbsp;</span>&nbsp;&nbsp;Status: <span id="_wc_file_manager_STATUS-'.$ID.'">Idle</span></td>'.'	</tr></table>'.'</td></tr>'.'<tr><td class="area-main"><div id="_wc_file_manager_FILES-'.$ID.'" class="wc-ui-fm-listing" style="width:\'+t_w+\'px">'.$hash_LIST->{'HTML'}.'</div></td></tr>'.'<tr><td>'.'	<table class="grid"><tr>'.'	<td class="area-button-left"><div id="wc-file-manager-button-CLOSE-'.$ID.'" class="div-button w-90" title="Close File Manger">Close</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-REFRESH-'.$ID.'" class="div-button w-90" title="Reload directory data">Refresh</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-SELECT-MASK-'.$ID.'" class="div-button w-120" title="Select by mask">Select (mask)</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-SELECT-ALL-'.$ID.'" class="div-button w-100" title="Select all">Select all</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-CLEAR-'.$ID.'" class="div-button w-130" title="Clear all selection">Clear selection</div></td>'.'	<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-EDIT-'.$ID.'" class="div-button w-80" title="Edit file(s)">Edit</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-REMOVE-'.$ID.'" class="div-button w-80" title="Remove file(s)/directory(s)">Remove</div></td>'.'	<td class="area-button-right"><div id="wc-file-manager-button-OPEN-'.$ID.'" class="div-button w-150" title="Open/View/Play file(s)">Open/Run/View/Play</div></td>'.'</tr></table>'.'<table class="grid"><tr>'.'	<td class="area-button-left" style="padding-top: 4px"><div id="wc-file-manager-button-DOWNLOAD-'.$ID.'" class="div-button w-90" title="Download file(s)">Download</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-manager-button-UPLOAD-'.$ID.'" class="div-button w-90" title="Upload file(s)">Upload</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.'	<td class="area-button-right s-message" style="padding-top: 3px">CHMOD:</td>'.'	<td class="area-button-right" style="padding-top: 4px"><input class="in-text" style="border: 1px solid #6a7070; width: 50px" type="text" id="_wc_file_manager_CHMOD-'.$ID.'" name="wc_file_manager_CHMOD-'.$ID.'" value="755"  onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-manager-button-CHMOD-'.$ID.'" class="div-button w-90" title="CHMOD file(s)/directory(s)">CHMOD</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-manager-button-RMBELOW-'.$ID.'" class="div-button w-270">Remove all messages below this box</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.'	<td class="area-button-right" style="padding-top: 4px">'.'		<input class="in-checkbox" style="margin-left: 3px" type="checkbox" id="_wc_file_manager_PATH-UPDATE-'.$ID.'" name="wc_file_manager_PATH-UPDATE-'.$ID.'" checked value="1"  onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /> <label class="s-message" title="If checked - global path will be synchronized with File Manager path" style="cursor: help" for="_wc_file_manager_PATH-UPDATE-'.$ID.'">Synchronize global path</label>'.'	</td>'.'</tr></table>'.'</td></tr>'.'</table></form>';
$HTML_message_MAIN=~s/\n/\\n/g;
$HTML_message_MAIN=~s/\r/\\r/g;
$result= <<HTML_EOF;
<div id="wc-file-manager-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	// Changing internal path
	WC.Console.State.change_dir('${HTML_message_PATH_TO_PROMPT}');
	// Getting width and height
	// var t_h = xClientHeight(); t_h -= 190; if (t_h < 100) t_h = 100;
	var t_w = xClientWidth(); t_w -= 90;
	if (NL.Browser.Detect.isIE) { if (t_w < 930) t_w = 930; }
	else { if (t_w < 1039) t_w = 1039; }
	var ff_style = (NL.Browser.Detect.isFF) ? ' style="padding-right: 12px"' : '';
	var path_input_WIDTH = (!NL.Browser.Detect.isIE7) ? 'width: 100%;' : 'width: 99%;';
	WC.UI.tab_set('wc-file-manager-CONTAINER-${ID}', 'File Manager', '${HTML_message_MAIN}', { 'ID': '_NO_ID_wc-file-manager-tab-${ID}', 'BOTTOM': '' });
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-CLOSE-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('wc-file-manager-CONTAINER-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('wc-file-manager-CONTAINER-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-REFRESH-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_manager_FILES-${ID}');
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_SELECTED = xGetElementById('_wc_file_manager_SELECTED-${ID}');
		if (obj_DATA && obj_PATH && obj_SELECTED) {
			WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Refreshing', 1);
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("REFRESHING", '#file _manager_ACTION',
				{ 'ACTION': 'refresh', 'dir': obj_PATH.value, 'js_ID': '${ID}' },
				[],
				{ 'type': 'hidden', 'id_TIMER': id_timer }
			);
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-CLEAR-${ID}', function () {
		WC.UI.Filemanager.selection_clear('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-SELECT-ALL-${ID}', function () {
		WC.UI.Filemanager.selection_all('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-SELECT-MASK-${ID}', function () {
		var obj_REGEX = xGetElementById('_wc-file-manager-REGEX-${ID}');
		var in_regex = prompt(''+
				"Please enter REGEX (regular expression) at JavaScript format, examples:\\n"+
				"   '.*' - anything;\\n"+
				"   '^test.*' - begins from 'test' and after that - anything;\\n"+
				"   '.*test\$' - begins from anything and ends with 'test';\\n"+
				"   '^\\\\d+\$' - digits only."+
				'', (obj_REGEX && obj_REGEX.value) ? obj_REGEX.value : '.*');
		if (obj_REGEX) obj_REGEX.value = in_regex;
		WC.UI.Filemanager.selection_regex('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}', in_regex);
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-EDIT-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				var is_edit = 1;
				/*if (arr_selected.length > 1) {
					if (!confirm("There are selected more than 1 element,\\nare you shure want to edit all of them?")) is_edit = 0;
				}*/
				if (is_edit) {
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("STARTING FILE(S) EDITING", '#file edit', { '-dir': obj_PATH.value }, arr_selected);
				}
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-GO-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_PATH_IN = xGetElementById('_wc_file_manager_PATH_IN-${ID}');
		var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-${ID}');
		if (obj_PATH && obj_PATH_IN && obj_SYNC) {
			if (!obj_PATH_IN.value) alert("There is not PATH entered,\\nPlease enter it.");
			else {
				WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
				var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Changing path', 1);
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("CHANGING PATH", '#file _manager_ACTION',
					{ 'ACTION': 'go', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'go_path': obj_PATH_IN.value, 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
					[],
					{ 'type': 'hidden', 'id_TIMER': id_timer }
				);
			}
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	xAddEventListener('_wc_file_manager_PATH_IN-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
			var obj_PATH_IN = xGetElementById('_wc_file_manager_PATH_IN-${ID}');
			var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-${ID}');
			if (obj_PATH && obj_PATH_IN && obj_SYNC) {
				if (!obj_PATH_IN.value) alert("There is not PATH entered,\\nPlease enter it.");
				else {
					WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
					var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Changing path', 1);
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHANGING PATH", '#file _manager_ACTION',
						{ 'ACTION': 'go', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'go_path': obj_PATH_IN.value, 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
						[],
						{ 'type': 'hidden', 'id_TIMER': id_timer }
					);
				}
			}
			else alert("Unable to find File Manager objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-UP-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-${ID}');
		if (obj_PATH && obj_SYNC) {
			WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Changing path (going upper)', 1);
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("CHANGING PATH (GOING UPPER)", '#file _manager_ACTION',
				{ 'ACTION': 'go_up', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
				[],
				{ 'type': 'hidden', 'id_TIMER': id_timer }
			);
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-REMOVE-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("REMOVING FILE(S)/DIRECTORY(S)", '#file remove', { '-dir': obj_PATH.value }, arr_selected);
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-OPEN-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("OPENING FILE(S)", '#file open', { '-dir': obj_PATH.value }, arr_selected);
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-DOWNLOAD-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("DOWNLOADING FILE(S)", '#file download', { '-dir': obj_PATH.value }, arr_selected);
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-CHMOD-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_CHMOD = xGetElementById('_wc_file_manager_CHMOD-${ID}');
		if (obj_PATH && obj_CHMOD) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
				else {
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE(S)/DIRECTORY(S)", '#file chmod '+obj_CHMOD.value, { '-dir': obj_PATH.value }, arr_selected);
				}
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	xAddEventListener('_wc_file_manager_CHMOD-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
			var obj_CHMOD = xGetElementById('_wc_file_manager_CHMOD-${ID}');
			if (obj_PATH && obj_CHMOD) {
				var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
				if (arr_selected.length > 0) {
					if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
					else {
						// OK, executing command
						WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE(S)/DIRECTORY(S)", '#file chmod '+obj_CHMOD.value, { 'dir': obj_PATH.value }, arr_selected);
					}
				}
				else alert("There are no elements selected.\\nPlease select something.");
			}
			else alert("Unable to find File Manager objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-UPLOAD-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("STARTING FILE(S) UPLOADING FORM", '#file upload "'+obj_PATH.value+'"');
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	/*
	// Adding BACK event
	xAddEventListener('_wc_file_manager_FILES-${ID}', 'keypress',  function (event) {
		alert('BACK EVENT - TEST');
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			return false;
		}
		return true;
	});
	*/
	// Adding scrolling event if it is needed
	/*
	var obj = xGetElementById('_wc_file_manager_FILES-${ID}');
	if (obj && obj.scrollWidth > obj.clientWidth) {
	*/
		NL.UI.object_event_SCROLL('_wc_file_manager_FILES-${ID}', function (event) {
			var obj = xGetElementById('_wc_file_manager_FILES-${ID}');
			if (obj && obj.scrollWidth > obj.clientWidth) {
				var pixels = 80;
				var d = NL.UI.object_event_SCROLL_get_delta(event);
				if (d < 0) obj.scrollLeft += pixels;
				else if (d > 0) obj.scrollLeft -= pixels;
				return false;
			}
			else return true;
		});
	/*}*/
	WC.UI.Filemanager.make_unselectable('_wc_file_manager_FILES-LIST-${ID}');
//--></script>
HTML_EOF
}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#file'}->{'manager'}->{'__func__'}->();
return$result;}},'_manager_ACTION'=>{'__doc__'=>'Internal method for File Manager actions (called when form internal action is needed)','__info__'=>'Manual call is not recommended.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD);
my$result='';
if(defined$hash_PARAMS->{'ACTION'}&&$hash_PARAMS->{'ACTION'}ne ''&&defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne ''){if($hash_PARAMS->{'ACTION'}eq 'refresh'){if(defined$hash_PARAMS->{'dir'}&&$hash_PARAMS->{'dir'}ne ''){my$hash_LIST=&manager_DIR_listing($hash_PARAMS->{'dir'},{'JS_ID'=>$hash_PARAMS->{'js_ID'},'MAKE_HTML_AS_JS_STRING'=>1});
if($hash_LIST->{'ID'}){$result=''.'<script type="text/JavaScript"><!--'."\n".'	var obj_TOTAL = xGetElementById(\'_wc_file_manager_TOTAL-'.$hash_PARAMS->{'js_ID'}.'\');'.'	var obj_SELECTED = xGetElementById(\'_wc_file_manager_SELECTED-'.$hash_PARAMS->{'js_ID'}.'\');'.'	var obj_FILES = xGetElementById(\'_wc_file_manager_FILES-'.$hash_PARAMS->{'js_ID'}.'\');'.'	if (obj_TOTAL && obj_SELECTED && obj_FILES) {'.'		obj_TOTAL.innerHTML = '.$hash_LIST->{'TOTAL'}.';'.'		obj_SELECTED.innerHTML = 0;'.'		obj_FILES.innerHTML = \''.$hash_LIST->{'HTML'}.'\';'.'		WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'		WC.Console.HTML.add_time_message(\'_wc_file_manager_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY HAS BEEN REFRESHED SUCCESSFULLY]\', { \'TIME\': 5 });'.'		WC.UI.Filemanager.make_unselectable(\'_wc_file_manager_FILES-LIST-'.$hash_PARAMS->{'js_ID'}.'\');'.'	}'.'	else alert("Unable to find File Manager objects (internal error)");'."\n".'//--></script>';}else{my$error=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY DATA CAN'T BE REFRESHED",'&nbsp;&nbsp;-&nbsp;'.$hash_LIST->{'ERROR'},{'ENCODE_TO_HTML'=>0}));
$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> REFRESHING DIRECTORY DATA</span>\', \''.$error.'\');'."\n".'//--></script>';}}else{my$error=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY DATA CAN'T BE REFRESHED",'  - Incorrect call, directory is not specified'));
$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> REFRESHING DIRECTORY DATA</span>\', \''.$error.'\');'."\n".'//--></script>';}}elsif($hash_PARAMS->{'ACTION'}eq 'go'){if(defined$hash_PARAMS->{'dir'}&&defined$hash_PARAMS->{'go_path'}&&$hash_PARAMS->{'go_path'}ne ''){my$hash_PATH={'GO_PATH'=>$hash_PARAMS->{'go_path'},'hash_PARAMS'=>$hash_PARAMS,'UPDATE_PATH'=>(defined$hash_PARAMS->{'update_path'}&&$hash_PARAMS->{'update_path'})?1:0};
$result=&manager_DIR_change($hash_PARAMS->{'dir'},$hash_PATH);}else{my$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'  - Incorrect call, directory is not specified'));
$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHANGING DIRECTORY</span>\', \''.$message.'\');'."\n".'//--></script>';}}elsif($hash_PARAMS->{'ACTION'}eq 'go_up'){if(defined$hash_PARAMS->{'dir'}&&$hash_PARAMS->{'dir'}ne ''){my$hash_PATH={'GO_PATH'=>'..','hash_PARAMS'=>$hash_PARAMS,'UPDATE_PATH'=>1};
$result=&manager_DIR_change($hash_PARAMS->{'dir'},$hash_PATH);}else{my$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'  - Incorrect call, directory is not specified'));
$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHANGING DIRECTORY (GOING UPPER)</span>\', \''.$message.'\');'."\n".'//--></script>';}}else{my$error=&NL::String::str_JS_value(&WC::HTML::get_message("FILE MANAGER ACTION CAN'T BE EXECUTED",'  - Incorrect call, unable to find needed objects'));
$result=''.'<script type="text/JavaScript"><!--'."\n".((defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne '')?' WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');':'').'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ FILE MANAGER ACTION</span>\', \''.$error.'\');'."\n".'//--></script>';}}else{my$error=&NL::String::str_JS_value(&WC::HTML::get_message("FILE MANAGER ACTION CAN'T BE EXECUTED",'  - Incorrect call, unable to find needed objects'));
$result=''.'<script type="text/JavaScript"><!--'."\n".((defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne '')?' WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');':'').'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ FILE MANAGER ACTION</span>\', \''.$error.'\');'."\n".'//--></script>';}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}},'open'=>{'__doc__'=>'Open/show file(s)','__info__'=>'Please type: <file name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n"."  Examples:\n"."    - #file open file.txt\n"."    - #file open image.jpg\n"."    - #file open file1.txt image1.jpg",'__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD,{'RETURN_ID'=>1,'AS_ARRAY'=>1,'ESCAPE_OFF'=>0,'DISALLOW_SPACES'=>1});
my$result='';
if(!$hash_PARAMS->{'ID'}){$result=&WC::HTML::get_message("FILE(S) CAN'T BE OPENED",'  - Incorect input, please specify file(s) correctly');}else{my$dir='';
my$dir_found=0;
my@arr_files;
foreach my $line(@{$hash_PARAMS->{'DATA'}}){foreach(keys%{$line}){if($_ ne ''){if(!$dir_found&&$_=~/^['"]{0,}-dir['"]{0,}$/i&&defined$line->{$_}){$dir_found=1;
$dir=$line->{$_};}else{my$path=$_;
if(defined$line->{$_}){$path.='='.$line->{$_};}push@arr_files,$path;}}}}my$is_OK=1;
if($dir_found){$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$result=&WC::HTML::get_message("FILE(S) CAN'T BE OPENED",'  - Incorrect TARGET DIRECTORY specified');
$is_OK=0;}elsif(!&WC::Dir::change_dir($dir)){$result=&WC::HTML::get_message("FILE(S) CAN'T BE OPENED",'&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});
$is_OK=0;}}if($is_OK){if(scalar@arr_files<=0){$result=&WC::HTML::get_message("FILE(S) CAN'T BE OPENED",'  - Incorect input, no file(s) specified');}else{my$MAX_FILES=5;
my$num_ok=0;
my$num_total=0;
$result='';
my$result_HTML='';
my$result_BAD='';
my$user_login_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
my$user_password_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});
&WC::Dir::update_current_dir();
my$dir_current=&WC::Dir::get_current_dir();
my$dir_current_ENC_INTERNAL=$dir_current;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$dir_current_ENC_INTERNAL);
my$dir_current_URL=&NL::String::str_HTTP_REQUEST_value($dir_current_ENC_INTERNAL);
my$result_GOOD_HTML_JS_VALUE='';
my$result_GOOD_JS='';
foreach(@arr_files){$num_total++;
my$path=&WC::Dir::check_in($_);
my$path_ENC_INTERNAL=$path;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_ENC_INTERNAL);
if($num_ok>=$MAX_FILES){$result_BAD.='<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' is not opened: <span class="t-red-dark">maximum opened files at the same time is '.$MAX_FILES.'</span></div>';}else{if(!-e$path){$result_BAD.='<div class="t-blue">&nbsp;&nbsp;-&nbsp;No file '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' found</div>';}elsif(!-f$path){$result_BAD.='<div class="t-blue">&nbsp;&nbsp;-&nbsp;'.&WC::HTML::get_short_value($path_ENC_INTERNAL).' is not a file</div>';}else{my$hash_OPEN=&WC::HTML::Open::start($path);
if($hash_OPEN->{'ID'}){$num_ok++;
$result_HTML.=$hash_OPEN->{'HTML'};}else{$result_BAD.=$hash_OPEN->{'HTML'};}}}}my$is_GOOD_needed=0;
if($num_total>1){$result="<div class=\"t-lime\">OPENING '$num_ok' OF '$num_total':</div>";
if($num_total>$num_ok){$result.="<div class=\"t-green\">&nbsp;&nbsp;Can't be opened:</div>".$result_BAD;}if($num_ok>0){$result.="<div class=\"t-green\">&nbsp;&nbsp;Opened:</div>\n";$is_GOOD_needed=1;}}else{if($num_ok>0){$is_GOOD_needed=1;}else{$result="<div class=\"t-lime\">FILE(S) CAN'T BE OPENDED:</div>".$result_BAD;}}if($is_GOOD_needed){my$ID=&WC::Internal::get_unique_id();
$result.='<div id="wc-open-CONTAINER-'.$ID.'">'.$result_HTML.'</div>';
if($num_ok>1){$result.="\n".'<script type="text/JavaScript"><!--'."\n"."WC.Console.HTML.OUTPUT_set_mark('wc-open-CONTAINER-$ID', 'DO_NOT_CLOSE_ALL');"."\n//--></script>\n";}}}}}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}},'show'=>'$$#file|open$$','download'=>{'__doc__'=>'Download file(s)','__info__'=>'Please type: <file name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n"."  Examples:\n"."    - #file download file.txt\n"."    - #file download file1.pl pack.tar.gz",'__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD,{'RETURN_ID'=>1,'AS_ARRAY'=>1,'ESCAPE_OFF'=>0,'DISALLOW_SPACES'=>1});
my$result='';
if(!$hash_PARAMS->{'ID'}){$result=&WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED",'  - Incorect input, please specify file(s) correctly');}else{my$dir='';
my$dir_found=0;
my@arr_files;
foreach my $line(@{$hash_PARAMS->{'DATA'}}){foreach(keys%{$line}){if($_ ne ''){if(!$dir_found&&$_=~/^['"]{0,}-dir['"]{0,}$/i&&defined$line->{$_}){$dir_found=1;
$dir=$line->{$_};}else{my$path=$_;
if(defined$line->{$_}){$path.='='.$line->{$_};}push@arr_files,$path;}}}}my$is_OK=1;
if($dir_found){$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$result=&WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED",'  - Incorrect TARGET DIRECTORY specified');
$is_OK=0;}elsif(!&WC::Dir::change_dir($dir)){$result=&WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED",'&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});
$is_OK=0;}}if($is_OK){if(scalar@arr_files<=0){$result=&WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED",'  - Incorect input, no file(s) specified');}else{my$MAX_FILES=5;
my$num_ok=0;
my$num_total=0;
$result='';
my$result_HTML='';
my$result_BAD='';
my$user_login_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
my$user_password_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});
&WC::Dir::update_current_dir();
my$dir_current=&WC::Dir::get_current_dir();
my$dir_current_ENC_INTERNAL=$dir_current;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$dir_current_ENC_INTERNAL);
my$dir_current_URL=&NL::String::str_HTTP_REQUEST_value($dir_current_ENC_INTERNAL);
my$result_GOOD_HTML_JS_VALUE='';
my$result_GOOD_JS='';
foreach(@arr_files){$num_total++;
my$path=&WC::Dir::check_in($_);
my$path_ENC_INTERNAL=$path;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_ENC_INTERNAL);
if($num_ok>=$MAX_FILES){$result_BAD.='<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' does not downloaded: <span class="t-red-dark">maximum downloaded files at the same time is '.$MAX_FILES.'</span></div>';}else{if(!-e$path){$result_BAD.='&nbsp;&nbsp;-&nbsp;No file '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' found<br />';}elsif(!-f$path){$result_BAD.='&nbsp;&nbsp;-&nbsp;'.&WC::HTML::get_short_value($path_ENC_INTERNAL).' is not a file<br />';}else{$num_ok++;
my$path_URL=&NL::String::str_HTTP_REQUEST_value($path_ENC_INTERNAL);
my$url=$WC::c->{'APP_SETTINGS'}->{'file_name'};
$url.='?q_action=download';
$url.='&user_login='.$user_login_URL;
$url.='&user_password='.$user_password_URL;
$url.='&dir='.$dir_current_URL;
$url.='&file='.$path_URL;
$result_HTML.='<span class="t-blue">&nbsp;&nbsp;-&nbsp;Starting downloading of the file '.&WC::HTML::get_short_value($path_ENC_INTERNAL,{'MAX_LENGTH'=>90}).' - <a href="'.$url.'" class="a-brown" target="_blank">click to download</a></span>';
$result_HTML.='<iframe src="'.$url.'" class="iframe-download">Your browser does not support IFRAME, that is needed for downloading</iframe>';
$result_HTML.='<br />';}}}my$is_GOOD_needed=0;
if($num_total>1){$result="<div class=\"t-lime\">STARTING DOWNLOADING FOR '$num_ok' OF '$num_total':</div>";
if($num_total>$num_ok){$result.="<div class=\"t-green\">&nbsp;&nbsp;Downloading can't be started for:</div>".'<div class="t-blue">'.$result_BAD.'</div>';}if($num_ok>0){$result.="<div class=\"t-green\">&nbsp;&nbsp;Downloading started for:</div>\n";$is_GOOD_needed=1;}}else{if($num_ok>0){$is_GOOD_needed=1;}else{$result="<div class=\"t-lime\">FILE(S) CAN'T BE DOWNLOADED:</div>".'<div class="t-blue">'.$result_BAD.'</div>';}}if($is_GOOD_needed){$result.='<div>'.$result_HTML.'</div>';}}}}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}},'get'=>'$$#file|download$$',};
sub edit_READ{my($in_FILE,$in_SETTINGS)=@_;
my$result={'ID'=>0,'ERROR'=>''};
if(!defined$in_FILE||$in_FILE eq ''){$result->{'ERROR'}='Incorrect call, file is not specified';return$result;}$in_SETTINGS={}if(!defined$in_SETTINGS);
if(!-e$in_FILE){$result->{'ERROR'}='File '.&WC::HTML::get_short_value($in_FILE).' does not exists';}elsif(!-r$in_FILE){$result->{'ERROR'}='File '.&WC::HTML::get_short_value($in_FILE).' is not readable by Web Console process';}else{my$max_edit_file_size=1048576;
$max_edit_file_size=$WC::CONST->{'INTERNAL'}->{'MAX_EDIT_FILE_SIZE'}if(defined$WC::CONST->{'INTERNAL'}&&defined$WC::CONST->{'INTERNAL'}->{'MAX_EDIT_FILE_SIZE'});
my$file_size=&WC::File::get_size($in_FILE);
if($file_size>$max_edit_file_size){$result->{'ERROR'}='File '.&WC::HTML::get_short_value($in_FILE).' size is too big '."(file size is '".(&NL::String::get_str_of_bytes($file_size))."', maximum recommended size is '".(&NL::String::get_str_of_bytes($max_edit_file_size))."')";}elsif(!&WC::File::lock_read($in_FILE,{'timeout'=>10,'time_sleep'=>0.1})){$result->{'ERROR'}='Unable to lock file '.&WC::HTML::get_short_value($in_FILE).' for reading';}else{if(!open(FH_EDIT_READ,'<'.$in_FILE)){$result->{'ERROR'}='Unable to open file '.&WC::HTML::get_short_value($in_FILE).' for reading'.(($!ne '')?': '.$!:'');}else{$result->{'FILE_DATA'}=join('',<FH_EDIT_READ>);
close(FH_EDIT_READ);
&WC::File::unlock($in_FILE);
&WC::Encode::encode_from_FILE_to_SYSTEM(\$result->{'FILE_DATA'});
if(!-w$in_FILE){$result->{'ID'}=2;
$result->{'ERROR'}='File '.&WC::HTML::get_short_value($in_FILE).' is not writable by Web Console process';}else{$result->{'ID'}=1;}}}}return$result;}sub edit_WRITE{my($in_FILE,$in_TEXT,$in_SETTINGS)=@_;
my$result={'ID'=>0,'ERROR'=>''};
if(!defined$in_FILE||$in_FILE eq ''){$result->{'ERROR'}='Incorrect call, file is not specified';return$result;}if(!defined$in_TEXT){$result->{'ERROR'}='Incorrect call, TEXT is not specified';return$result;}$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'HARDSAVE'}=0 if(!defined$in_SETTINGS->{'HARDSAVE'});
if(!$in_SETTINGS->{'HARDSAVE'}&&!-e$in_FILE){$result->{'ERROR'}='File '.&WC::HTML::get_short_value($in_FILE).' does not exists';}elsif(!$in_SETTINGS->{'HARDSAVE'}&&!-w$in_FILE){$result->{'ERROR'}='File '.&WC::HTML::get_short_value($in_FILE).' is not writable by Web Console process';}else{&WC::Encode::encode_from_SYSTEM_to_FILE(\$in_TEXT);
if(&WC::File::save($in_FILE,$in_TEXT,{'BINMODE'=>(defined$in_SETTINGS->{'USE_BINMODE'}&&$in_SETTINGS->{'USE_BINMODE'})?1:0})!=1){$result->{'ERROR'}=&WC::File::get_last_error_TEXT();
my$additional_info=&WC::File::get_last_error_INFO();
$result->{'ERROR'}.=': '.$additional_info if($additional_info ne '');}else{$result->{'ID'}=1;}}return$result;}sub edit_FORM{my($in_FILE,$in_SETTINGS)=@_;
$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'DIV_HIDDEN'}=0 if(!defined$in_SETTINGS->{'DIV_HIDDEN'});
my$result={'ID'=>0,'HTML'=>'','HTML_JS_VALUE'=>'','JS'=>'','DIV_ID'=>''};
if(!defined$in_FILE||$in_FILE eq ''){$result->{'HTML'}='<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;Incorrect call of FORM creation, file is not specified';
return$result;}my$path_encoded=$in_FILE;
&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_encoded);
if(!-e$in_FILE){$result->{'HTML'}='<div class="t-blue">&nbsp;&nbsp;-&nbsp;No file '.&WC::HTML::get_short_value($path_encoded).' found</div>';
return$result;}elsif(-d$in_FILE){$result->{'HTML'}='<div class="t-blue">&nbsp;&nbsp;-&nbsp;Directory '.&WC::HTML::get_short_value($path_encoded).' can\'t be edited, please specify a file</div>';
return$result;}my$hash_READ=&edit_READ($in_FILE);
if($hash_READ->{'ID'}<=0){&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$hash_READ->{'ERROR'});
$result->{'HTML'}='<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;'.$hash_READ->{'ERROR'};}else{my$ID=&WC::Internal::get_unique_id();
$in_SETTINGS->{'ID'}=$ID if(!defined$in_SETTINGS->{'ID'});
&NL::String::str_HTML_value(\$hash_READ->{'FILE_DATA'});
&NL::String::str_JS_value(\$hash_READ->{'FILE_DATA'});
my$HTML_message_FILE_NAME_SHORT=&NL::String::str_JS_value(&WC::HTML::get_short_value($in_FILE));
my$HTML_message_FILE_NAME_VALUE=&NL::String::str_JS_value(&NL::String::str_HTML_value($in_FILE));
&WC::Dir::update_current_dir();
my$HTML_message_DIR=&NL::String::str_JS_value(&NL::String::str_HTML_value(&WC::Dir::get_current_dir()));
my$HTML_message_READONLY=($hash_READ->{'ID'}==2)?" <span class=\"s-warning\">(FILE IS READONLY - IT CAN\\'T BE SAVED)</span>":'';
my$str_ENCODING='';
my$file_ENCODING=&WC::Encode::get_encoding('editor_text');
if($file_ENCODING ne ''){if($WC::Encode::ENCODE_ON){$file_ENCODING=&NL::String::get_right($file_ENCODING,20,1);
$str_ENCODING="WC.Console.HTML.add_time_message('_wc_file_edit_SPAN-FILE-MESSAGE-$ID', '  [opened with encoding: $file_ENCODING]', { 'TIME': 10 })";}else{$str_ENCODING="WC.Console.HTML.add_time_message('_wc_file_edit_STATUS-MESSAGE-$ID', '[ENCODINGS CONVERSION DISABLED, CHECK &quot;<a class=\"t-cmd\" href=\"#\" onclick=\"WC.Console.Prompt.value_set(\\'#settings\\'); return false\" title=\"Click to paste at command input\">#settings</a>&quot;]', { 'TIME': 30, 'IS_HTML': 1 })";}}my$HTML_message_TEXTAREA='<textarea wrap="off" style="width: \'+t_w+\'px; height: \'+t_h+\'px" id="_wc_file_edit_DATA-'.$ID.'" name="wc_file_edit_DATA-'.$ID.'">'."\n".$hash_READ->{'FILE_DATA'}.'</textarea>';
my$HTML_message_MAIN=''.'<div id="wc-file-edit-DIV-CONTAINER-'.$ID.'"'.(($in_SETTINGS->{'DIV_HIDDEN'})?' style="display: none"':'').'>'.'<form id="wc-file-edit-form-'.$ID.'" action="" onsubmit="return false" target="_blank">'.'<input type="hidden" id="_wc-file-edit-FILENAME-'.$ID.'" name="wc-file-edit-FILENAME-'.$ID.'" value="'.$HTML_message_FILE_NAME_VALUE.'" />'.'<input type="hidden" id="_wc-file-edit-DIR-'.$ID.'" name="wc-file-edit-DIR-'.$ID.'" value="'.$HTML_message_DIR.'" />'.'<table class="grid" style="width: 100%">'.'	<tr><td>'.'		<table class="grid" style="width: 100%"><tr>'.'			<td class="area-info-left">Edit/view file '.$HTML_message_FILE_NAME_SHORT.$HTML_message_READONLY.':<span class="span-file-message" id="_wc_file_edit_SPAN-FILE-MESSAGE-'.$ID.'">&nbsp;</span></td>'.'			<td class="area-info-right"><span class="span-message" id="_wc_file_edit_STATUS-MESSAGE-'.$ID.'">&nbsp;</span>&nbsp;&nbsp;Status: <span id="_wc_file_edit_STATUS-'.$ID.'">Idle</span></td>'.'		</tr></table>'.'	</td></tr>'.'<tr><td class="area-main">'.$HTML_message_TEXTAREA.'</td></tr>'.'<tr><td>'.'<table class="grid"><tr>'.'<td class="area-button-left"><div id="wc-file-edit-button-CLOSE-'.$ID.'" class="div-button w-100" title="Close file(s) without saving">Close</div></td>'.'<td class="area-button-right"><div id="wc-file-edit-button-RELOAD-'.$ID.'" class="div-button w-100" title="Reload file content">Reload</div></td>';
if($hash_READ->{'ID'}==1){$HTML_message_MAIN.=''.'<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.'<td class="area-button-right"><div id="wc-file-edit-button-SAVE-'.$ID.'" class="div-button w-100" title="Save file without closing">Save</div></td>'.'<td class="area-button-right"><div id="wc-file-edit-button-SAVE_CLOSE-'.$ID.'" class="div-button w-120" title="Save file and close">Save and close</div></td>';}if($hash_READ->{'ID'}==1){$HTML_message_MAIN.=''.'<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.'<td class="area-button-right" style="padding-left: 0"><input class="in-checkbox" style="margin-left: 9px" type="checkbox" id="_wc-file-edit-BINMODE-'.$ID.'" name="wc-file-edit-BINMODE-'.$ID.'" value="1" /> <label class="s-message" \'+font_style_small+\'title="By default file will be saved at TEXT mode" style="cursor: help" for="_wc-file-edit-BINMODE-'.$ID.'">Save at BINARY mode</label></td>'.'<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.'<td class="area-button-right" style="padding-left: 0"><input class="in-checkbox" style="margin-left: 9px" type="checkbox" id="_wc-file-edit-HARDSAVE-'.$ID.'" name="wc-file-edit-HARDSAVE-'.$ID.'" value="1" /> <label class="s-message" \'+font_style_small+\'title="By default file will not be saved if it is does not exists" style="cursor: help" for="_wc-file-edit-HARDSAVE-'.$ID.'">Save, if file does not exists</label></td>';}$HTML_message_MAIN.=''.'</tr></table>'.'<table class="grid"><tr>'.'	<td class="area-button-left" style="padding-top: 4px"><div id="wc-file-edit-button-RMBELOW-'.$ID.'" class="div-button w-270">Remove all messages below this box</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-edit-button-DOWNLOAD-'.$ID.'" class="div-button w-90" title="Download file(s)">Download</div></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.'	<td class="area-button-right s-message" style="padding-top: 3px">CHMOD:</td>'.'	<td class="area-button-right" style="padding-top: 4px"><input class="in-text" style="border: 1px solid #6a7070; width: 50px" type="text" id="_wc_file_edit_CHMOD-'.$ID.'" name="wc_file_edit_CHMOD-'.$ID.'" value="755"  onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /></td>'.'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-edit-button-CHMOD-'.$ID.'" class="div-button w-90" title="CHMOD file(s)/directory(s)">CHMOD</div></td>'.'</tr></table>'.'</td></tr>'.'</table></form></div>';
$HTML_message_MAIN=~s/\n/\\n/g;
$HTML_message_MAIN=~s/\r/\\r/g;
$result->{'HTML_JS_VALUE'}=$HTML_message_MAIN;
$result->{'DIV_ID'}='wc-file-edit-DIV-CONTAINER-'.$ID;
$result->{'JS'}= <<HTML_EOF;
<script type="text/JavaScript"><!--
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-CLOSE-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('wc-file-edit-CONTAINER-${$in_SETTINGS}{'ID'}'); });
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('wc-file-edit-DIV-CONTAINER-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-RELOAD-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_edit_DATA-${ID}');
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_DATA && obj_FILENAME && obj_FILENAME.value && obj_DIR) {
			var HTML_name_short = NL.String.toHTML( NL.String.get_str_right_dottes(obj_FILENAME.value, 30) );
			WC.Console.HTML.set_INNER('_wc_file_edit_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_edit_STATUS-${ID}', 'Reloading', 1);
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("RELOADING FILE '"+HTML_name_short+"'", '#file _edit_reload', {
				'js_ID': '${ID}', 'js_id_DATA': '_wc_file_edit_DATA-${ID}', 'file_name': obj_FILENAME.value, 'dir': obj_DIR.value
			}, [], { 'type': 'hidden', 'id_TIMER': id_timer });
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
HTML_EOF
if($hash_READ->{'ID'}==1){$result->{'JS'}.= <<HTML_EOF;
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-SAVE-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_edit_DATA-${ID}');
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_DATA && obj_FILENAME && obj_FILENAME.value && obj_DIR) {
			var HTML_name_short = NL.String.toHTML( NL.String.get_str_right_dottes(obj_FILENAME.value, 30) );
			var use_binmode = 0;
			var obj_BINMODE = xGetElementById('_wc-file-edit-BINMODE-${ID}');
			if (obj_BINMODE && obj_BINMODE.checked) use_binmode = 1;
			var enable_hardsave = 0;
			var obj_HARDSAVE = xGetElementById('_wc-file-edit-HARDSAVE-${ID}');
			if (obj_HARDSAVE && obj_HARDSAVE.checked) enable_hardsave = 1;
			WC.Console.HTML.set_INNER('_wc_file_edit_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_edit_STATUS-${ID}', 'Saving', 1);
			NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': id_timer});
			// OK, executing command
			WC.Console.AJAX.query({}, {
					'q_action': 'AJAX_FILE_SAVE',
					'js_ID': '${ID}',
					'use_binmode': use_binmode,
					'enable_hardsave': enable_hardsave,
					'file_name': obj_FILENAME.value,
					'file_data': obj_DATA.value,
					'dir': obj_DIR.value
				},
				function (in_JS_DATA, in_STASH) {
					if (in_JS_DATA && in_JS_DATA['STASH'] && in_JS_DATA['STASH']['JS_CODE']) eval(in_JS_DATA['STASH']['JS_CODE']);
				},
				{});
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-SAVE_CLOSE-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_edit_DATA-${ID}');
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_DATA && obj_FILENAME && obj_FILENAME.value && obj_DIR) {
			var HTML_name_short = NL.String.toHTML( NL.String.get_str_right_dottes(obj_FILENAME.value, 30) );
			var use_binmode = 0;
			var obj_BINMODE = xGetElementById('_wc-file-edit-BINMODE-${ID}');
			if (obj_BINMODE && obj_BINMODE.checked) use_binmode = 1;
			var enable_hardsave = 0;
			var obj_HARDSAVE = xGetElementById('_wc-file-edit-HARDSAVE-${ID}');
			if (obj_HARDSAVE && obj_HARDSAVE.checked) enable_hardsave = 1;
			WC.Console.HTML.set_INNER('_wc_file_edit_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_edit_STATUS-${ID}', 'Saving and closing', 1);
			NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': id_timer});
			// OK, executing command
			WC.Console.AJAX.query({}, {
					'q_action': 'AJAX_FILE_SAVE_CLOSE',
					'js_ID': '${ID}',
					'use_binmode': use_binmode,
					'enable_hardsave': enable_hardsave,
					'file_name': obj_FILENAME.value,
					'file_data': obj_DATA.value,
					'dir': obj_DIR.value
				},
				function (in_JS_DATA, in_STASH) {
					if (in_JS_DATA && in_JS_DATA['STASH'] && in_JS_DATA['STASH']['JS_CODE']) eval(in_JS_DATA['STASH']['JS_CODE']);
				},
				{});
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
HTML_EOF
}$result->{'JS'}.= <<HTML_EOF;
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-CHMOD-$ID', function () {
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		var obj_CHMOD = xGetElementById('_wc_file_edit_CHMOD-${ID}');
		if (obj_FILENAME && obj_DIR && obj_CHMOD) {
			if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
			else {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE", '#file chmod '+obj_CHMOD.value, { '-dir': obj_DIR.value }, [obj_FILENAME.value]);
			}
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
	xAddEventListener('_wc_file_edit_CHMOD-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
			var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
			var obj_CHMOD = xGetElementById('_wc_file_edit_CHMOD-${ID}');
			if (obj_FILENAME && obj_DIR && obj_CHMOD) {
				if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
				else {
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE", '#file chmod '+obj_CHMOD.value, { '-dir': obj_DIR.value }, [obj_FILENAME.value]);
				}
			}
			else alert("Unable to find EDITOR objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-DOWNLOAD-$ID', function () {
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_FILENAME && obj_DIR) {
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("DOWNLOADING FILE", '#file download', { '-dir': obj_DIR.value }, [obj_FILENAME.value]);
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
	$str_ENCODING
HTML_EOF
$result->{'JS'}.="\n".'//--></script>'."\n";
$result->{'ID'}=1;}return$result;}sub manager_DIR_listing{my($in_DIR,$in_SETTINGS)=@_;
my$result={'ID'=>0,'TOTAL'=>0,'ERROR'=>''};
if(!defined$in_DIR||$in_DIR eq ''){$result->{'ERROR'}='Incorrect call, directory is not specified';return$result;}$in_SETTINGS={}if(!defined$in_SETTINGS);
$in_SETTINGS->{'NO_BACK'}=0 if(!defined$in_SETTINGS->{'NO_BACK'});
my$dir_SPLITTER=&WC::Dir::get_dir_splitter();
if(!-d$in_DIR){$result->{'ERROR'}='No directory '.(&WC::HTML::get_short_value($in_DIR)).' found';}else{my$re_SKIP=qr/^\.{1,2}$/;
if(opendir(DIR,$in_DIR)){my@arr_listing_DIRS;
my@arr_listing_FILES;
my@arr_listing=grep(!/$re_SKIP/,readdir(DIR));
closedir(DIR);
foreach(@arr_listing){if(-d$in_DIR.$dir_SPLITTER.$_){push@arr_listing_DIRS,$_.$dir_SPLITTER;}else{push@arr_listing_FILES,$_;}}$result->{'ARR_LIST'}=[(map{{'path'=>$_,'type'=>'dir'}}sort@arr_listing_DIRS),(map{{'path'=>$_,'type'=>'file'}}sort@arr_listing_FILES)];
$result->{'TOTAL'}=scalar@{$result->{'ARR_LIST'}};
if(!$in_SETTINGS->{'NO_BACK'}){unshift@{$result->{'ARR_LIST'}},{'path'=>'..'.$dir_SPLITTER,'type'=>'back'};}$result->{'ID'}=1;}else{$result->{'ERROR'}='Unable to get directory '.&WC::HTML::get_short_value($in_DIR).' listing'.(($!ne '')?': '.$!:'');}}if($result->{'ID'}&&defined$in_SETTINGS->{'MAKE_HTML_AS_JS_STRING'}&&$in_SETTINGS->{'MAKE_HTML_AS_JS_STRING'}){my$total=scalar@{$result->{'ARR_LIST'}};
my$js_ID=(defined$in_SETTINGS->{'JS_ID'})?$in_SETTINGS->{'JS_ID'}:'';
$result->{'HTML'}='';
my$i=0;
my$MAX_AT_COLUMN=20;
foreach(@{$result->{'ARR_LIST'}}){my$class=$_->{'type'};
my$value=&NL::String::str_HTML_value($_->{'path'});
$value=~s/ /&nbsp;/g;
$result->{'HTML'}.='</td><td class="wc-ui-fm-block">' if($i%$MAX_AT_COLUMN==0&&$i+1<$total&&$result->{'HTML'}ne '');
$result->{'HTML'}.='<div class="'.$class.'" onclick="WC.UI.Filemanager.activate(this, { \'id_files_selected\': \'_wc_file_manager_SELECTED-'.$js_ID.'\' }); return false;" ondblclick="WC.UI.Filemanager.double_click(this, \''.$js_ID.'\', \''.$class.'\'); return false;">'.$value.'</div>';
$i++;}if($i>($in_SETTINGS->{'NO_BACK'}?0:1)){if($i<$MAX_AT_COLUMN){my$j=$i;
while($j<$MAX_AT_COLUMN){$result->{'HTML'}.='<div class="free">&nbsp;</div>';$j++;}}}else{$result->{'HTML'}.='<div class="free empty">[directory is empty]</div>';
$i++;
while($i<$MAX_AT_COLUMN){$result->{'HTML'}.='<div class="free">&nbsp;</div>';$i++;}}$result->{'HTML'}=&NL::String::str_JS_value('<table class="grid" id="_wc_file_manager_FILES-LIST-'.$js_ID.'"><tr><td class="wc-ui-fm-block">'.$result->{'HTML'}.'</td></tr></table>');}return$result;}sub manager_DIR_remove{my($in_DIR)=@_;
my$result={'ID'=>0,'ERROR'=>''};
if(!defined$in_DIR||$in_DIR eq ''){$result->{'ERROR'}='Incorrect call, directory is not specified';return$result;}my$hash_DIR=&manager_DIR_listing($in_DIR,{'NO_BACK'=>1});
if(!$hash_DIR->{'ID'}){$result->{'ERROR'}=$hash_DIR->{'ERROR'};return$result;}else{my$dir_SPLITTER=&WC::Dir::get_dir_splitter();
my$dir_S=$in_DIR;
$dir_S.=$dir_SPLITTER if($dir_S!~/$dir_SPLITTER$/);
foreach(@{$hash_DIR->{'ARR_LIST'}}){my$rm_path=$dir_S.$_->{'path'};
if(-d$rm_path){my$hash_RM=&manager_DIR_remove($rm_path);
if(!$hash_RM->{'ID'}){$result->{'ERROR'}=$hash_RM->{'ERROR'};return$result;}}else{if((unlink$rm_path)<=0){$result->{'ERROR'}='Unable to remove file '.&WC::HTML::get_short_value($rm_path).(($!ne '')?': '.$!:'');return$result;}}}if(!rmdir$in_DIR){$result->{'ERROR'}='Unable to remove directory '.&WC::HTML::get_short_value($in_DIR).(($!ne '')?': '.$!:'');return$result;}else{$result->{'ID'}=1;return$result;}}}sub manager_DIR_change{my($in_DIR,$in_SETTING)=@_;
$in_SETTING={}if(!defined$in_SETTING);
$in_SETTING->{'GO_PATH'}='' if(!defined$in_SETTING->{'GO_PATH'});
$in_SETTING->{'hash_PARAMS'}={}if(!defined$in_SETTING->{'hash_PARAMS'});
$in_SETTING->{'UPDATE_PATH'}=0 if(!defined$in_SETTING->{'UPDATE_PATH'});
my$is_OK=0;
my$result='';
my$message='';
if(!defined$in_DIR||$in_DIR eq ''){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'  - Incorrect call, directory is not specified'));}else{my$dir=&WC::Dir::check_in($in_DIR);
my$dir_path=&WC::Dir::check_in($in_SETTING->{'GO_PATH'});
if($dir eq ''){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'  - Incorrect call, directory is not specified'));}elsif(!-d$dir){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'&nbsp;&nbsp;-&nbsp;No directory '.(&WC::HTML::get_short_value($dir)).' found',{'ENCODE_TO_HTML'=>0}));}elsif(!&WC::Dir::change_dir($dir)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'&nbsp;&nbsp;-&nbsp;Unable change directory to '.(&WC::HTML::get_short_value($dir)).(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0}));}elsif($dir_path ne ''&&!-d$dir_path){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'&nbsp;&nbsp;-&nbsp;No directory '.(&WC::HTML::get_short_value($dir_path)).' found',{'ENCODE_TO_HTML'=>0}));}elsif($dir_path ne ''&&!&WC::Dir::change_dir($dir_path)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'&nbsp;&nbsp;-&nbsp;Unable change directory to '.(&WC::HTML::get_short_value($dir_path)).(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0}));}else{&WC::Dir::update_current_dir();
$dir=&WC::Dir::get_current_dir();
my$dir_JS=&NL::String::str_JS_value($dir);
my$hash_LIST=&manager_DIR_listing($dir,{'JS_ID'=>$in_SETTING->{'hash_PARAMS'}->{'js_ID'},'MAKE_HTML_AS_JS_STRING'=>1});
if($hash_LIST->{'ID'}){$is_OK=1;
$result=''.'<script type="text/JavaScript"><!--'."\n".'	var obj_PATH = xGetElementById(\'_wc-file-manager-PATH-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	var obj_PATH_IN = xGetElementById(\'_wc_file_manager_PATH_IN-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	var obj_TOTAL = xGetElementById(\'_wc_file_manager_TOTAL-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	var obj_SELECTED = xGetElementById(\'_wc_file_manager_SELECTED-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	var obj_FILES = xGetElementById(\'_wc_file_manager_FILES-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	if (obj_PATH && obj_PATH_IN && obj_TOTAL && obj_SELECTED && obj_FILES) {'.'		obj_PATH.value = \''.$dir_JS.'\';'.'		obj_TOTAL.innerHTML = '.$hash_LIST->{'TOTAL'}.';'.'		obj_SELECTED.innerHTML = 0;'.'		obj_FILES.innerHTML = \''.$hash_LIST->{'HTML'}.'\';'.'		WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'		WC.Console.HTML.add_time_message(\'_wc_file_manager_STATUS-MESSAGE-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\', \'[DIRECTORY HAS BEEN CHANGED SUCCESSFULLY]\', { \'TIME\': 5 });'.(($in_SETTING->{'UPDATE_PATH'})?'obj_PATH_IN.value = \''.$dir_JS.'\';':'').((defined$in_SETTING->{'hash_PARAMS'}->{'synchronize_global_path'}&&$in_SETTING->{'hash_PARAMS'}->{'synchronize_global_path'})?'WC.Console.State.change_dir(\''.$dir_JS.'\');':'').'		WC.UI.Filemanager.make_unselectable(\'_wc_file_manager_FILES-LIST-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	}'.'	else alert("Unable to find File Manager objects (internal error)");'."\n".'//--></script>';}else{$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED",'&nbsp;&nbsp;-&nbsp;'.$hash_LIST->{'ERROR'},{'ENCODE_TO_HTML'=>0}));}}}if(!$is_OK){$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHANGING DIRECTORY</span>\', \''.$message.'\');'."\n".'//--></script>';}return$result;}sub AJAX_save{my($in_PARAMS,$in_IS_CLOSE_AFTER_SAVING)=@_;
$in_PARAMS={}if(!defined$in_PARAMS);
$in_IS_CLOSE_AFTER_SAVING=0  if(!defined$in_IS_CLOSE_AFTER_SAVING);
my$hash_PARAMS=$in_PARAMS;
my$check_RESULT=&NL::Parameter::check($hash_PARAMS,{'file_data'=>{'name'=>'File DATA','needed'=>1,'can_be_empty'=>1},'file_name'=>{'name'=>'Filename','needed'=>1},'dir'=>{'name'=>'Directory path','needed'=>1,'can_be_empty'=>1},'use_binmode'=>{'name'=>'Use BINARY mode','needed'=>0},'js_ID'=>{'name'=>'Element ID','needed'=>1},'enable_hardsave'=>{'name'=>'Enable save, if file does not exists','needed'=>0}});
my$result='';
if(!$check_RESULT->{'ID'}){my$error=&NL::String::str_JS_value(&WC::HTML::get_message("FILE CAN'T BE SAVED",'  - '.$check_RESULT->{'ERROR_MESSAGE'}));
my$file=(defined$hash_PARAMS->{'file_name'}&&$hash_PARAMS->{'file_name'}ne '')?&NL::String::str_JS_value(&WC::HTML::get_short_value($hash_PARAMS->{'file_name'})):&NL::String::str_JS_value(&WC::HTML::get_short_value('_UNKNOWN_'));
$result=''.((defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne '')?' WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');':'').'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> SAVING FILE '.$file.'</span>\', \''.$error.'\');'."\n";}else{my$is_OK=0;
my$message='';
my$dir=&WC::Dir::check_in($hash_PARAMS->{'dir'});
if($dir ne ''&&!&WC::Dir::change_dir($dir)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("FILE CAN'T BE SAVED",'  - Incorrect TARGET DIRECTORY specified'));}else{my$hash_SAVE=&edit_WRITE($hash_PARAMS->{'file_name'},$hash_PARAMS->{'file_data'},{'USE_BINMODE'=>(defined$hash_PARAMS->{'use_binmode'}&&$hash_PARAMS->{'use_binmode'})?1:0,'HARDSAVE'=>(defined$hash_PARAMS->{'enable_hardsave'}&&$hash_PARAMS->{'enable_hardsave'})?1:0});
if(!$hash_SAVE->{'ID'}){$message=&NL::String::str_JS_value(&WC::HTML::get_message("FILE CAN'T BE SAVED",'&nbsp;&nbsp;- '.$hash_SAVE->{'ERROR'},{'ENCODE_TO_HTML'=>0}));}else{$is_OK=1;
my$text_at_binmode=(defined$hash_PARAMS->{'use_binmode'}&&$hash_PARAMS->{'use_binmode'})?' (AT BINMODE)':'';
$message=&NL::String::str_JS_value("FILE HAS BEEN SUCCESSFULLY SAVED".$text_at_binmode);}}my$file=&NL::String::str_JS_value(&WC::HTML::get_short_value($hash_PARAMS->{'file_name'}));
$result='WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\'); ';
if($is_OK){$result.='WC.Console.HTML.add_time_message(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'['.$message.']\', { \'TIME\': 5 }); ';
if($in_IS_CLOSE_AFTER_SAVING){$result.='WC.Console.HTML.OUTPUT_remove_result(\'wc-file-edit-DIV-CONTAINER-'.$hash_PARAMS->{'js_ID'}.'\');';
$message=&NL::String::str_JS_value(&WC::HTML::get_message("FILE HAS BEEN SUCCESSFULLY SAVED",'  - File has been successfully saved, edit window has been closed'));
$result.='WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> SAVING FILE '.$file.'</span>\', \''.$message.'\');';}}else{$result.='var obj = xGetElementById(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\'); if (obj) obj.innerHTML = \'\'; ';
$result.='WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> SAVING FILE '.$file.'</span>\', \''.$message.'\');';}}&WC::AJAX::show_response('','AJAX_FILE_SAVE',{},{'JS_CODE'=>$result});
return 1;}package WC::Internal::Data::Upload;
use strict;
$WC::Internal::DATA::ALL->{'#file'}->{'upload'}={'__doc__'=>'Upload file(s)','__info__'=>$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'open file(s) uploading form.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$result='';
my$check=&WC::Internal::Data::Upload::upload_CHECK();
if($check->{'ID'}){my$init_UPLOAD=&NL::AJAX::Upload::init();
if($init_UPLOAD->{'ID'}){$result=&WC::Internal::Data::Upload::upload_FORM();}else{$result=&WC::Internal::Data::Upload::upload_NO_CGI_PM($init_UPLOAD->{'ERROR_MSG'});}}else{$result=$check->{'MESSAGE'};}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;},'__func_auto__'=>sub{my$result=\%{$WC::Internal::DATA::AC_RESULT};
$result->{'TEXT'}=$WC::Internal::DATA::ALL->{'#file'}->{'upload'}->{'__func__'}->();
return$result;}};
$WC::Internal::DATA::ALL->{'#file'}->{'send'}='$$#file|upload$$';
$WC::Internal::DATA::ALL->{'#file'}->{'_upload_action'}={'__doc__'=>'Internal method for uploading ACTIONS','__info__'=>'Manual call is not recommended.','__func__'=>sub{my($in_CMD)=@_;
$in_CMD='' if(!defined$in_CMD);
my$hash_PARAMS=&WC::Internal::pasre_parameters($in_CMD);
my$result='';
if(defined$hash_PARAMS->{'ACTION'}&&$hash_PARAMS->{'ACTION'}ne ''&&defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne ''){if($hash_PARAMS->{'ACTION'}eq 'check_path'){if(defined$hash_PARAMS->{'dir'}&&defined$hash_PARAMS->{'dir'}ne ''){my$message='';
my$is_OK=0;
my$dir=&WC::Dir::check_in($hash_PARAMS->{'dir'});
if($dir eq ''){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CHECKING RESULT",'  - Incorrect input directory (incorrect parameter)'));}elsif(!-d$dir){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CHECKING RESULT",'&nbsp;&nbsp;-&nbsp;No directory '.(&WC::HTML::get_short_value($dir)).' found',{'ENCODE_TO_HTML'=>0}));}elsif(!&WC::Dir::change_dir($dir)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CHECKING RESULT",'&nbsp;&nbsp;-&nbsp;Unable change directory to '.(&WC::HTML::get_short_value($dir)).(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0}));}else{my$JS_addon_PATH='';
if(defined$hash_PARAMS->{'synchronize_global_path'}&&$hash_PARAMS->{'synchronize_global_path'}){&WC::Dir::update_current_dir();
my$dir_current=&WC::Dir::get_current_dir();
$JS_addon_PATH='WC.Console.State.change_dir(\''.&NL::String::str_JS_value($dir_current).'\');';}$is_OK=1;
$result=''.'<script type="text/JavaScript"><!--'."\n".$JS_addon_PATH.'	WC.UI.Upload.update_dir_list([], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY IS VALID]\', { \'TIME\': 5 });'."\n".'//--></script>';}if(!$is_OK){$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.UI.Upload.update_dir_list([], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHECKING DIRECTORY</span>\', \''.$message.'\');'."\n".'//--></script>';}}else{my$message=&NL::String::str_JS_value(&WC::HTML::get_message("DIRECTORY CAN'T BE CHECKED",'  - Incorrect call, directory is not specified'));
$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHECKING DIRECTORY</span>\', \''.$message.'\');'."\n".'//--></script>';}}elsif($hash_PARAMS->{'ACTION'}eq 'load_sudirs'){if(defined$hash_PARAMS->{'dir'}&&defined$hash_PARAMS->{'dir'}ne ''){my$message='';
my$is_OK=0;
my$dir=&WC::Dir::check_in($hash_PARAMS->{'dir'});
if($dir eq ''){$message=&NL::String::str_JS_value(&WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT",'  - Incorrect input directory (incorrect parameter)'));}elsif(!-d$dir){$message=&NL::String::str_JS_value(&WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT",'&nbsp;&nbsp;-&nbsp;No directory '.(&WC::HTML::get_short_value($dir)).' found',{'ENCODE_TO_HTML'=>0}));}elsif(!&WC::Dir::change_dir($dir)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT",'&nbsp;&nbsp;-&nbsp;Unable change directory to '.(&WC::HTML::get_short_value($dir)).(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0}));}else{my$is_sub_OK=1;
my$sub_dir=(defined$hash_PARAMS->{'sub_dir'})?&WC::Dir::check_in($hash_PARAMS->{'sub_dir'}):'';
if($sub_dir ne ''){$is_sub_OK=0;
if(!&WC::Dir::change_dir($sub_dir)){$message=&NL::String::str_JS_value(&WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT",'&nbsp;&nbsp;-&nbsp;Unable change directory to '.(&WC::HTML::get_short_value($sub_dir)).(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0}));}else{$is_sub_OK=2;}}&WC::Dir::update_current_dir();
my$dir=&WC::Dir::get_current_dir();
if($is_sub_OK!=0){my$dir_SPLITTER=&WC::Dir::get_dir_splitter();
if(opendir(DIR,$dir)){my@arr_listing=grep(!/^$/,map{(-d$dir.$dir_SPLITTER.$_)?$_:''}grep(!/^\.{1,2}$/,readdir(DIR)));
closedir(DIR);
@arr_listing=sort@arr_listing;
my$total=scalar@arr_listing;
$is_OK=1;
my$JS_addon_PATH='';
if(defined$hash_PARAMS->{'synchronize_global_path'}&&$hash_PARAMS->{'synchronize_global_path'}){$JS_addon_PATH='WC.Console.State.change_dir(\''.&NL::String::str_JS_value($dir).'\');';}my$JS_PATH_UPDATE='';
if($is_sub_OK==2){my$js_dir=&NL::String::str_JS_value($dir);
$JS_PATH_UPDATE=''.'	var obj_PATH = xGetElementById(\'wc-upload-dir-'.$hash_PARAMS->{'js_ID'}.'\');'.'	if (obj_PATH) obj_PATH.value = \''.$js_dir.'\';'.'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY IS EMPTY]\', { \'TIME\': 5 });'."\n".'';}if($total<=0){$result=''.'<script type="text/JavaScript"><!--'."\n".$JS_PATH_UPDATE.$JS_addon_PATH.'	WC.UI.Upload.update_dir_list([], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY IS EMPTY]\', { \'TIME\': 5 });'."\n".'//--></script>';}else{my$js_ARRAY='';
foreach(@arr_listing){if($_ ne ''){$js_ARRAY.="," if($js_ARRAY ne '');
$js_ARRAY.="'".&NL::String::str_JS_value($_)."'";}}$result=''.'<script type="text/JavaScript"><!--'."\n".$JS_PATH_UPDATE.$JS_addon_PATH.'	WC.UI.Upload.update_dir_list(['.$js_ARRAY.'], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[SUBDIRECTORYS LOADED]\', { \'TIME\': 5 });'."\n".'//--></script>';}}else{$message=&NL::String::str_JS_value(&WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT",'Unable to get directory '.&WC::HTML::get_short_value($dir).' listing'.(($!ne '')?': '.$!:''),{'ENCODE_TO_HTML'=>0}));}}}if(!$is_OK){$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> LOADING SUBDIRECTORYS</span>\', \''.$message.'\');'."\n".'//--></script>';}}else{my$message=&NL::String::str_JS_value(&WC::HTML::get_message("SUBDIRECTORYS CAN'T BE LOADED",'  - Incorrect call, directory is not specified'));
$result=''.'<script type="text/JavaScript"><!--'."\n".'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> LOADING SUBDIRECTORYS</span>\', \''.$message.'\');'."\n".'//--></script>';}}else{my$error=&NL::String::str_JS_value(&WC::HTML::get_message("UPLOADER ACTION CAN'T BE EXECUTED",'  - Incorrect call, unable to find needed objects'));
$result=''.'<script type="text/JavaScript"><!--'."\n".((defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne '')?' WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');':'').'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ UPLOADER ACTION</span>\', \''.$error.'\');'."\n".'//--></script>';}}else{my$error=&NL::String::str_JS_value(&WC::HTML::get_message("UPLOADER ACTION CAN'T BE EXECUTED",'  - Incorrect call, unable to find needed objects'));
$result=''.'<script type="text/JavaScript"><!--'."\n".((defined$hash_PARAMS->{'js_ID'}&&$hash_PARAMS->{'js_ID'}ne '')?' WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');':'').'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ UPLOADER ACTION</span>\', \''.$error.'\');'."\n".'//--></script>';}return$WC::Internal::DATA::HEADERS->{'text/html'}.$result;}};
sub upload_CHECK{my$result={'ID'=>1,'MESSAGE'=>''};
return$result;}sub upload_FORM{&WC::Dir::update_current_dir();
my$dir_current_HTML=&NL::String::str_JS_value(&NL::String::str_HTML_value(&WC::Dir::get_current_dir()));
my$CGI_PM_WARNING='';
my$UPLOAD_STATUS_METHOD=$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK?'STATUS_FILE':'POST_FILE';
if(!$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK){$CGI_PM_WARNING='<tr><td class="wc-upload-td-buttons s-warning" style="padding-top: 6px" colspan="2">WARNING: Your \'CGI.pm\' Perl module '.'(your version \''.$CGI::VERSION.'\') is too old, not fully featured uploading will be used. Recommended \'CGI.pm\' version is >= \'3.03\', please <a class="link-warning" href="http://search.cpan.org/~lds/CGI.pm/CGI.pm" target="_blank">update</a> your \'CGI.pm\' Perl module.</td></tr>';
$CGI_PM_WARNING=~s/'/\\'/g;}my$ID=&WC::Internal::get_unique_id();
my$HTML_message_MAIN= <<HTML_EOF;
	<div id="wc-upload-layout-div-MAIN-${ID}">
		<form id="wc-upload-FORM-${ID}" name="_wc-upload-FORM-${ID}" method="post" enctype="multipart/form-data" onsubmit="return false">
	 	<input id="wc-upload-FORM-ID-${ID}" type="hidden" name="_wc-upload-FORM-ID-${ID}" value="$ID" />
	 	<input id="wc-upload-FORM-DIR-${ID}" type="hidden" name="_wc-upload-FORM-DIR-${ID}" value="$dir_current_HTML" />
		<table id="wc-upload-layout-div-MAIN-TAB-${ID}" class="grid">
			<tr><td colspan="2">
				<table class="grid" style="width: 100%"><tr>
					<td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Select file(s) for uploading:</span></td>
					<td class="wc-upload-info-right"><span class="span-message" id="wc-upload-STATUS-MESSAGE-${ID}">&nbsp;</span>&nbsp;&nbsp;Status: <span id="wc-upload-STATUS-${ID}">Idle</span></td>
				</tr></table>
			</td></tr>
			<tr>
				<td id="wc-upload-files-area-${ID}" class="wc-upload-files" colspan="2"><input type="file" class="'+wc_fu_class_input_file+'" id="${ID}-wc-upload-file-1" name="_${ID}-wc-upload-file-1"'+wc_fu_class_INPUT_FILE_fix+' /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Current directory:</span></td>
				<td class="area-right-long"><input class="wc-upload-input-dir" type="text" id="wc-upload-dir-${ID}" name="_wc-upload-dir-${ID}" value="$dir_current_HTML" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Upload to:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left">
							<select id="wc-upload-dir-list-${ID}" name="_wc-upload-dir-list-${ID}" class="wc-upload-input-select"'+wc_fu_class_UPLOAD_DIR_LIST_FIX+'>
								<option value="" selected>&nbsp;***CURRENT DIRECTORY***&nbsp;</option>
							</select>
						</td>
						<td class="wc-upload-area-select-left"><div id="wc-upload-button-dir-reload-${ID}" class="wc-upload-div-button-dir-reload">load subdirectorys</div></td>
						<td class="wc-upload-area-select-right"><div id="wc-upload-area-dir-reload-status-${ID}" class="wc-upload-dir-reload-status">&nbsp;</div></td>
					</tr></table>
				</td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Create subdirectory:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left"><input class="wc-upload-input" id="wc-upload-form-dir-create-${ID}" name="_wc-upload-form-dir-create-${ID}" /></td>
						<td class="wc-upload-area-select-right"><span class="wc-upload-small-info">(file(s) will be created inside that directory)</span></td>
					</tr></table>
				</td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Set file(s) permissions:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left"><input id="wc-upload-form-permissions-${ID}" class="wc-upload-input-permissions" name="_wc-upload-form-permissions-${ID}" /></td>
						<td class="wc-upload-area-select-right"><span class="wc-upload-small-info">(example - &quot;777&quot;, if permissions entered - it will be applied to all uploaded files)</span></td>
					</tr></table>
				</td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Use ASCII mode:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left"><input id="wc-upload-form-ASCII-${ID}" class="wc-upload-checkbox-ASCII" type="checkbox" name="_wc-upload-form-ASCII-${ID}" value="0" /></td>
						<td class="wc-upload-area-select-right"><span class="wc-upload-small-info">useful for auto text files convertion between WINDOWS (&quot;\\\\r\\\\n&quot;) and UNIX (&quot;\\\\n&quot;)</span></td>
					</tr></table>
				</td>
			</tr>
			<tr><td class="wc-upload-td-buttons" colspan="2">
				<table class="grid"><tr>
					<td class="area-button-left"><div id="wc-upload-button-upload-${ID}" class="div-button w-100">upload</div></td>
					<td class="area-button-right"><div id="wc-upload-button-close-${ID}" class="div-button w-100">close</div></td>
					<td class="area-button-right"><div id="wc-upload-button-slot-plus-${ID}" class="div-button w-120">+1 upload slot</div></td>
					<td class="area-button-right"><div id="wc-upload-button-slot-minus-${ID}" class="div-button w-120 wc-upload-div-button-unactive">-1 upload slot</div></td>
				</tr></table>
				<table class="grid"><tr>
					<td class="area-button-left" style="padding-top: 4px"><div id="wc-upload-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
					<td class="area-button-right" style="padding-top: 4px">
						<input class="in-checkbox" style="margin-left: 3px" type="checkbox" id="wc-upload-PATH-UPDATE-${ID}" name="_wc-upload-PATH-UPDATE-${ID}" value="1" onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /> <label class="s-message" title="If checked - global path will be synchronized with Uploader path" style="cursor: help" for="wc-upload-PATH-UPDATE-${ID}">Synchronize global path</label>
					</td>
				</tr></table>
			</td></tr>
			$CGI_PM_WARNING
		</table>
	 </form></div>
	 <div id="wc-upload-layout-div-PROGRESS-${ID}" style="display: none"></div>
	 <div id="wc-upload-layout-div-FINISH-${ID}" style="display: none"></div>
HTML_EOF
$HTML_message_MAIN=~s/\n/\\n/g;
$HTML_message_MAIN=~s/\r/\\r/g;
my$user_login_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
my$user_password_URL=&NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});
my$result= <<HTML_EOF;
<div id="wc-file-upload-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	// Getting width and height
	// var t_h = xClientHeight(); t_h -= 190; if (t_h < 100) t_h = 100;
	var t_w = xClientWidth(); t_w -= 80; if (t_w < 100) t_w = 100;
	var ff_style = (NL.Browser.Detect.isFF) ? ' style="padding-right: 12px"' : '';
	var wc_fu_class_input_file = !NL.Browser.Detect.isOPERA ? 'wc-upload-input-file' : 'wc-upload-input-file-opera';
	if (NL.Browser.Detect.isFF3) wc_fu_class_input_file = 'wc-upload-input-file-ff3';
	var wc_fu_ff_INPUT_FILE_size = (NL.Browser.Detect.isFF3) ? 108 : 107;
	var wc_fu_class_INPUT_FILE_fix = (NL.Browser.Detect.isFF) ? ' size="'+wc_fu_ff_INPUT_FILE_size+'"' : '';
	var wc_fu_class_UPLOAD_DIR_LIST_FIX = '';
	// Don't setting fixed 'width' because width will be automatically changed
	// if (NL.Browser.Detect.isFF) wc_fu_class_UPLOAD_DIR_LIST_FIX = ' style="width: 228px"';
	// else if (NL.Browser.Detect.isOPERA) wc_fu_class_UPLOAD_DIR_LIST_FIX = ' style="width: 226px"';
	WC.UI.tab_set('wc-file-upload-CONTAINER-${ID}', 'Upload File(s)', '${HTML_message_MAIN}', { 'ID': '_NO_ID_wc-file-upload-tab-${ID}', 'BOTTOM': '' });
	NL.UI.div_button_register('div-button', 'wc-upload-button-RMBELOW-${ID}', function () { WC.Console.HTML.OUTPUT_remove_below('wc-upload-layout-div-MAIN-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-upload-button-close-${ID}', function () { WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-upload-button-slot-plus-${ID}', function () { WC.UI.Upload.slots('add', { 'id': '${ID}', 'input_class': wc_fu_class_input_file, 'ff_size': wc_fu_ff_INPUT_FILE_size }); });
	NL.UI.div_button_register('div-button', 'wc-upload-button-slot-minus-${ID}', function () { WC.UI.Upload.slots('remove', { 'id': '${ID}', 'input_class': wc_fu_class_input_file, 'ff_size': wc_fu_ff_INPUT_FILE_size }); });
	xAddEventListener('wc-upload-dir-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_PATH = xGetElementById('wc-upload-dir-${ID}');
			var obj_SYNC = xGetElementById('wc-upload-PATH-UPDATE-${ID}');
			if (obj_PATH && obj_SYNC) {
				if (!obj_PATH.value) alert("There is not CURRENT DIRECTORY entered,\\nPlease enter it.");
				else {
					WC.Console.HTML.set_INNER('wc-upload-STATUS-MESSAGE-${ID}', '');
					var id_timer = WC.Console.status_change('wc-upload-STATUS-${ID}', 'Checking path', 1);
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHECKING PATH", '#file _upload_action',
						{ 'ACTION': 'check_path', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
						[],
						{ 'type': 'hidden', 'id_TIMER': id_timer }
					);
				}
			}
			else alert("Unable to find Uploader objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('wc-upload-div-button-dir-reload', 'wc-upload-button-dir-reload-${ID}', function () {
		var obj_PATH = xGetElementById('wc-upload-dir-${ID}');
		var obj_LIST = xGetElementById('wc-upload-dir-list-${ID}');
		var obj_SYNC = xGetElementById('wc-upload-PATH-UPDATE-${ID}');
		if (obj_PATH && obj_LIST && obj_SYNC) {
			if (!obj_PATH.value) alert("There is not CURRENT DIRECTORY entered,\\nPlease enter it.");
			else {
				WC.Console.HTML.set_INNER('wc-upload-STATUS-MESSAGE-${ID}', '');
				var id_timer = WC.Console.status_change('wc-upload-STATUS-${ID}', 'Loading subdirectorys', 1);
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("LOADING SUBDIRECTORYS", '#file _upload_action',
					{ 'ACTION': 'load_sudirs', 'dir': obj_PATH.value, 'sub_dir': obj_LIST.value, 'js_ID': '${ID}', 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
					[],
					{ 'type': 'hidden', 'id_TIMER': id_timer }
				);
			}
		}
		else alert("Unable to find Uploader objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-upload-button-upload-${ID}', function () {
		var obj_PATH = xGetElementById('wc-upload-dir-${ID}');
		var obj_LIST = xGetElementById('wc-upload-dir-list-${ID}');
		var obj_CREATE = xGetElementById('wc-upload-form-dir-create-${ID}');
		var obj_PERMISSIONS = xGetElementById('wc-upload-form-permissions-${ID}');
		var obj_ASCII = xGetElementById('wc-upload-form-ASCII-${ID}');
		if (obj_PATH && obj_LIST && obj_CREATE && obj_PERMISSIONS && obj_ASCII) {
			if (!obj_PATH.value) alert("There is not CURRENT DIRECTORY entered,\\nPlease enter it.");
			else {
				// Generating files list
				var obj = xGetElementById('wc-upload-files-area-${ID}');
				var arr_Files = [];
				if (obj) {
					var sub_nodes = obj.childNodes;
					if (sub_nodes) {
						if (NL.Browser.Detect.isSAFARI) {
							var chld = [];
							for (var i = 0; i < sub_nodes.length; i++) chld[i] = sub_nodes[i];
							sub_nodes = chld;
						}
						var id_str = '${ID}';
						var id_len = id_str.length;
						NL.foreach(sub_nodes, function (i, val) {
							var is_OK = 1;
							if (NL.Browser.Detect.isOPERA) {
								if (i.substring(0, id_str.length) != id_str) is_OK = 0;
							}
							if (is_OK && val.type == 'file' && val.value != '') { arr_Files.push(val); }
						});
					}
				}
				if (arr_Files.length <= 0) { alert('There are no files selected,\\nplease select files to uploading.'); }
				else {
					var FILES_TOTAL = arr_Files.length;
					WC.Console.HTML.set_INNER('wc-upload-STATUS-MESSAGE-${ID}', '');
					var id_timer = WC.Console.status_change('wc-upload-STATUS-${ID}', 'Starting uploading', 1);
					NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': id_timer});
					// Uploading files
					var obj_UPLOAD_STARTED = WC.UI.Upload.start('${ ${ $WC::c }{'APP_SETTINGS'} }{'file_name'}', {
						'user_login': '$user_login_URL',
						'user_password': '$user_password_URL',
						'dir': obj_PATH.value,
						'dir_sub': obj_LIST.value,
						'dir_create': obj_CREATE.value,
						'file_permissions': obj_PERMISSIONS.value,
						'mode_ASCII': obj_ASCII.checked ? 1 : 0,
						'js_ID': '${ID}',
						'FILES': arr_Files
					});
					NL.Cache.add('${ID}', obj_UPLOAD_STARTED);
					if (obj_UPLOAD_STARTED) {
						var timer_interval = 1000;
						WC.UI.Upload.state_PROGRESS({ 'js_ID': '${ID}', 'UPLOAD_STATUS_METHOD': '$UPLOAD_STATUS_METHOD' });
						NL.Timer.timer_add_exec_and_on(timer_interval, function(in_STASH, in_TIME) {
							if (in_STASH && in_STASH['js_ID']) {
								if (WC.UI.Upload.state_PROGRESS_IS_ACTIVE(in_STASH['js_ID'])) {
									if (WC.UI.Upload.state_PROGRESS_update_TIME({ 'js_ID': in_STASH['js_ID'] }, in_TIME)) {
										var obj_UPLOADING = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+in_STASH['js_ID']);
										if (obj_UPLOADING && obj_UPLOADING.value && parseInt(obj_UPLOADING.value)) {
											NL.AJAX.query('${ ${ $WC::c }{'APP_SETTINGS'} }{'file_name'}', {
													'q_action': 'AJAX_UPLOAD_STATUS',
													'user_login': '$user_login_URL',
													'user_password': '$user_password_URL',
													'js_ID': '${ID}',
													'UPLOAD_STATUS_METHOD': '$UPLOAD_STATUS_METHOD'
												}, {},
												function(respJS, respTEXT) {
													if (respJS && respJS['STASH']) {
														if (respJS['STASH']['CODE']) {
															if (respJS['STASH']['CODE'] == 'OK') {
																WC.UI.Upload.state_PROGRESS_update({ 'js_ID': '${ID}' }, respJS['STASH']['STATUS'], { 'UPLOAD_STATUS_METHOD': '$UPLOAD_STATUS_METHOD', 'FILES_TOTAL': FILES_TOTAL });
															}
														}
													}
													var obj_STATUS_REQUESTED = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_REQUESTED-${ID}');
													if(obj_STATUS_REQUESTED) obj_STATUS_REQUESTED.value = 0;
												});
										}
									}
									return 1;
								}
							}
							// Timer for that element will be killed automatically
							return 0;
						}, {'js_ID': '${ID}'}, { 'SLEEP_MS': 3000 });
					}
					else alert("Unable to start uploading");
				}
			}
		}
		else alert("Unable to find Uploader objects (internal error)");
	});
//--></script>
HTML_EOF
return$result;}sub upload_NO_CGI_PM{my($in_ERROR)=@_;
my$text="&nbsp;&nbsp;No 'CGI.pm' module found, that Perl module is needed for uploading,<br />";
$text.='&nbsp;&nbsp;that module can be downloaded from CPAN: <a class="a-brown" href="http://search.cpan.org/~lds/CGI.pm/CGI.pm" target="_blank">http://search.cpan.org/~lds/CGI.pm/CGI.pm</a><br />';
$text.='<br />';
$text.='<div class="t-red-light">&nbsp;&nbsp;Additional information:</div>';
my$in_message=$in_ERROR;
&NL::String::str_trim(\$in_message);
$in_message=~s/^/  - /;
$in_message=~s/\n/\n    /g;
&NL::String::str_HTML_full(\$in_message);
return '<div class="t-lime">FILE(S) CAN\'T BE UPLOADED:</div><div class="t-blue">'.$text.$in_message.'</div>';}package WC::Upload;
use strict;
$WC::Upload::NL_INIT={};
sub _set_NL_INIT{$WC::Upload::NL_INIT={'DIR_TEMP'=>$WC::c->{'config'}->{'directorys'}->{'temp'},'POST_MAX'=>50*(1024*1024)};
if(defined$WC::c->{'config'}&&defined$WC::c->{'config'}->{'uploading'}&&defined$WC::c->{'config'}->{'uploading'}->{'limit'}){if($WC::c->{'config'}->{'uploading'}->{'limit'}=~/^\d+$/){$WC::Upload::NL_INIT->{'POST_MAX'}=$WC::c->{'config'}->{'uploading'}->{'limit'}*(1024*1024);}}}sub process{my$params=$WC::c->{'req'}->{'params'};
my$result={'CODE'=>'ERROR','MESSAGE'=>''};
my$message='';
if(!defined$params->{'dir'}||$params->{'dir'}eq ''){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'  - NO DIRECTORY specified');}elsif(!defined$params->{'js_ID'}||$params->{'js_ID'}eq ''){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'  - NO SID specified');}elsif(defined$params->{'file_permissions'}&&$params->{'file_permissions'}ne ''&&$params->{'file_permissions'}!~/^\d+$/){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED","  - File(s) permissions is incorrect, correct example: '755'");}else{my$dir=$params->{'dir'};
&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'  - Incorrect NO DIRECTORY specified');}elsif(!&WC::Dir::change_dir($dir)){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});}else{my$is_OK=1;
if(defined$params->{'dir_sub'}&&$params->{'dir_sub'}ne ''){$is_OK=0;
$dir=$params->{'dir_sub'};
&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'  - Incorrect SUBDIRECTORY specified');}elsif(!&WC::Dir::change_dir($dir)){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'&nbsp;&nbsp;- Subdirectory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});}else{$is_OK=1;}}&_set_NL_INIT();
my$init_UPLOAD=&NL::AJAX::Upload::init($WC::Upload::NL_INIT);
if($init_UPLOAD->{'ID'}){if($is_OK){if(defined$params->{'dir_create'}&&$params->{'dir_create'}ne ''){$is_OK=0;
$dir=$params->{'dir_create'};
&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
$dir=&WC::Dir::check_in($dir);
if($dir eq ''){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'  - Incorrect DIRECTORY FOR CREATION specified');}elsif(!&WC::Dir::change_dir($dir)){if(!mkdir($dir)){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'&nbsp;&nbsp;- Subdirectory '.&WC::HTML::get_short_value($dir).' can\'t be created'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});}else{if(!&WC::Dir::change_dir($dir)){$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",'&nbsp;&nbsp;- Created subdirectory '.&WC::HTML::get_short_value($dir).' is not accessible'.(($!ne '')?': <span class="t-green-light">'.$!.'</span>':''),{'ENCODE_TO_HTML'=>0});}else{$is_OK=1;}}}else{$is_OK=1;}}}if($is_OK){my$file_permissions='';
my$use_binmode=1;
if(defined$params->{'file_permissions'}&&$params->{'file_permissions'}ne ''){$file_permissions=$params->{'file_permissions'};}if(defined$params->{'mode_ASCII'}&&$params->{'mode_ASCII'}){$use_binmode=0;}my$hash_UPLOAD=&NL::AJAX::Upload::start_upload({'SID'=>$params->{'js_ID'}},{'FILES_PERMISSIONS'=>$file_permissions,'BINMODE'=>$use_binmode});
if($hash_UPLOAD->{'ID'}){$result->{'CODE'}='OK';
$result->{'UPLOADS'}=$hash_UPLOAD->{'UPLOADS'};
$result->{'INFO'}=$hash_UPLOAD->{'INFO'};}else{$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",$hash_UPLOAD->{'ERROR_MSG'},{'AUTO_BR'=>1});}}}else{$message=&WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED",$init_UPLOAD->{'ERROR_MSG'},{'AUTO_BR'=>1});}}}if($result->{'CODE'}ne 'OK'){$result->{'MESSAGE'}=$message;}&WC::AJAX::show_response('','AJAX_UPLOAD_RESULT',{},$result);
return 1;}sub process_get_status{my$params=$WC::c->{'req'}->{'params'};
my$result={'CODE'=>'ERROR','MESSAGE'=>'','STATUS'=>{},'METHOD'=>''};
if(!defined$params->{'js_ID'}||$params->{'js_ID'}eq ''){$result->{'MESSAGE'}=&WC::HTML::get_message("CAN'T GET UPLOADING STATUS",'  - NO SID specified');}else{my$IN_UPLOAD_STATUS_METHOD='';
if(defined$params->{'UPLOAD_STATUS_METHOD'}){$IN_UPLOAD_STATUS_METHOD=$params->{'UPLOAD_STATUS_METHOD'};}&_set_NL_INIT();
my$init_UPLOAD=&NL::AJAX::Upload::init($WC::Upload::NL_INIT);
if($init_UPLOAD->{'ID'}){my$hash_UPLOAD_STATUS=&NL::AJAX::Upload::status_get($params->{'js_ID'},{'METHOD'=>$IN_UPLOAD_STATUS_METHOD});
if($hash_UPLOAD_STATUS->{'ID'}){$result->{'STATUS'}=$hash_UPLOAD_STATUS->{'STATUS'};
$result->{'METHOD'}=$hash_UPLOAD_STATUS->{'METHOD'};
$result->{'CODE'}='OK';}else{$result->{'CODE'}='OK_NO_STATUS';
$result->{'METHOD'}=$hash_UPLOAD_STATUS->{'METHOD'};
$result->{'MESSAGE'}=$hash_UPLOAD_STATUS->{'ERROR_MSG'};}}else{$result->{'MESSAGE'}=&WC::HTML::get_message("CAN'T GET UPLOADING STATUS",$init_UPLOAD->{'ERROR_MSG'},{'AUTO_BR'=>1});}}&WC::AJAX::show_response('','AJAX_UPLOAD_STATUS',{},$result);
return 1;}sub get_dir_list{my($in_ref_hash_FORM_PARAMS)=@_;
my$req_params=$in_ref_hash_FORM_PARAMS;
my$ref_arr_dir_list=[];
my$cur_dir=$WC::c->{'config'}->{'dir_work'};
if(defined$req_params->{'dir_from_list'}&&$req_params->{'dir_from_list'}ne ''){$cur_dir=$req_params->{'dir_from_list'};}$cur_dir.='/' if($cur_dir!~/[\\\/]$/);
if($cur_dir ne ''){push@{$ref_arr_dir_list},$cur_dir;
chdir($cur_dir);}foreach(@{&WC::Utils::dir_list('./',1)}){if(-d$_){push@{$ref_arr_dir_list},$cur_dir.$_;}}return$ref_arr_dir_list;}&WC::CORE::start();

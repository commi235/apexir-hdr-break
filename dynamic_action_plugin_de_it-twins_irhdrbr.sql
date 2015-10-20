set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.2.00.06'
,p_default_workspace_id=>26036287808504013104
,p_default_application_id=>79731
,p_default_owner=>'MK_TEST'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/de_it_twins_irhdrbr
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(15118483690763480972)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.IT-TWINS.IRHDRBR'
,p_display_name=>'IR Header Linebreaks'
,p_category=>'STYLE'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'  c_js_function constant varchar2(4000) := ',
'q''[function de_itt_apexir_hdr_break()',
'{ apex.server.plugin',
'  (',
'    ''#AJAX_IDENT#''',
'  , { x01: this.affectedElements[0].id }',
'  , { success: function( pData ) ',
'               { apex.jQuery.each( pData, function(index, value)',
'                   { apex.jQuery("#" + index + " > a").html(value); }',
'                 ); ',
'               }',
'    }',
'    );',
'};]'';',
'  ',
'  cursor cur_ir_cols is',
'    select coalesce( aapic.static_id, ''C'' || aapic.column_id ) column_id',
'         , aapic.form_label',
'      from apex_application_page_ir_col aapic',
'         , apex_application_page_regions aapr',
'     where aapic.region_id = aapr.region_id',
'       and aapr.application_id = apex_application.g_flow_id',
'       and ( aapr.region_id = to_number( regexp_substr( apex_application.g_x01, ''\d+'') )',
'          or aapr.static_id = apex_application.g_x01',
'           )',
'       and aapic.report_label != aapic.form_label',
'  ;',
'',
'function render',
'  (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin',
'  )',
'    return apex_plugin.t_dynamic_action_render_result',
'  as',
'    l_affected_elements apex_application_page_da_acts.affected_elements%type;',
'    ',
'    ',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'  begin',
'    l_result.javascript_function := ''de_itt_apexir_hdr_break'';',
'    l_result.ajax_identifier := apex_plugin.get_ajax_identifier;',
'',
'    apex_plugin_util.debug_dynamic_action',
'    (',
'      p_plugin => p_plugin,',
'      p_dynamic_action => p_dynamic_action',
'    );',
'    ',
'    apex_javascript.add_inline_code',
'    (',
'      p_code => replace(c_js_function, ''#AJAX_IDENT#'', l_result.ajax_identifier),',
'      p_key => ''de_itt_apexir_hdr_pkg''',
'    );',
'    ',
'    return l_result;',
'  end render;',
'',
'  function callback',
'  (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin',
'  )',
'    return apex_plugin.t_dynamic_action_ajax_result',
'  as',
'    l_result apex_plugin.t_dynamic_action_ajax_result;',
'  begin',
'    apex_plugin_util.debug_dynamic_action',
'    (',
'      p_plugin => p_plugin,',
'      p_dynamic_action => p_dynamic_action',
'    );',
'    apex_debug.message',
'    (',
'      p_message => ''Value of x01: %s'',',
'      p0 => apex_application.g_x01',
'    );',
'',
'    apex_json.open_object;',
'    for rec in cur_ir_cols',
'    loop',
'      apex_json.write( p_name => rec.column_id, p_value => rec.form_label);',
'    end loop;',
'    apex_json.close_all;',
'    ',
'    return l_result;',
'  end callback;'))
,p_render_function=>'render'
,p_ajax_function=>'callback'
,p_standard_attributes=>'TRIGGERING_ELEMENT:REQUIRED:ONLOAD'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'This plugin allows you to utilize the "Single Row View Labels" as column headings for the report view.<br />',
'To use the plugin follow the steps below:',
'<ul>',
'<li>Create a dynamic action targeting one or multiple interactive reports.</li>',
'<li>As action choose "IR Header Linebreaks".</li>',
'<li>Set "Affected Elements" to "Triggering Element" and leave "Fire on Page Load" set to "Yes".</li>',
'</ul>',
'You can also put the dynamic action on the global page and use ".a-IRR" as jQuery selector to enable the plugin for all interactive reports in the application.'))
,p_version_identifier=>'0.5'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done

CREATE OR REPLACE PACKAGE APEXIR_HDR_BREAK_PKG
  AUTHID CURRENT_USER
AS

  function render
  (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin
  )
    return apex_plugin.t_dynamic_action_render_result
  ;

  function callback
  (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin
  )
    return apex_plugin.t_dynamic_action_ajax_result
  ;

END APEXIR_HDR_BREAK_PKG;
/

CREATE OR REPLACE PACKAGE BODY APEXIR_HDR_BREAK_PKG
AS

  c_js_function constant varchar2(4000) :=
q'[function de_itt_apexir_hdr_break()
{ apex.server.plugin
  (
    '#AJAX_IDENT#'
  , { x01: this.affectedElements[0].id }
  , { success: function( pData )
               { apex.jQuery.each( pData, function(index, value)
                   { apex.jQuery("#" + index + " > a").html(value); }
                 );
               }
    }
    );
};]';

  cursor cur_ir_cols is
    select coalesce( aapic.static_id, 'C' || aapic.column_id ) column_id
         , aapic.form_label
      from apex_application_page_ir_col aapic
         , apex_application_page_regions aapr
     where aapic.region_id = aapr.region_id
       and aapr.application_id = apex_application.g_flow_id
       and ( aapr.region_id = to_number( regexp_substr( apex_application.g_x01, '\d+') )
          or aapr.static_id = apex_application.g_x01
           )
       and aapic.report_label != aapic.form_label
  ;

function render
  (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin
  )
    return apex_plugin.t_dynamic_action_render_result
  as
    l_affected_elements apex_application_page_da_acts.affected_elements%type;


    l_result apex_plugin.t_dynamic_action_render_result;
  begin
    l_result.javascript_function := 'de_itt_apexir_hdr_break';
    l_result.ajax_identifier := apex_plugin.get_ajax_identifier;

    apex_plugin_util.debug_dynamic_action
    (
      p_plugin => p_plugin,
      p_dynamic_action => p_dynamic_action
    );

    apex_javascript.add_inline_code
    (
      p_code => replace(c_js_function, '#AJAX_IDENT#', l_result.ajax_identifier),
      p_key => 'de_itt_apexir_hdr_pkg'
    );

    return l_result;
  end render;

  function callback
  (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin
  )
    return apex_plugin.t_dynamic_action_ajax_result
  as
    l_result apex_plugin.t_dynamic_action_ajax_result;
  begin
    apex_plugin_util.debug_dynamic_action
    (
      p_plugin => p_plugin,
      p_dynamic_action => p_dynamic_action
    );
    apex_debug.message
    (
      p_message => 'Value of x01: %s',
      p0 => apex_application.g_x01
    );

    apex_json.open_object;
    for rec in cur_ir_cols
    loop
      apex_json.write( p_name => rec.column_id, p_value => rec.form_label);
    end loop;
    apex_json.close_all;

    return l_result;
  end callback;

END APEXIR_HDR_BREAK_PKG;
/

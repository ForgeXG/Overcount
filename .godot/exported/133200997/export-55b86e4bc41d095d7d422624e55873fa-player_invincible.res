RSRC                    VisualShader            ��������                                            5      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script    size    expression 	   constant    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/4/size    nodes/fragment/4/input_ports    nodes/fragment/4/output_ports    nodes/fragment/4/expression    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_ss3wt        $   local://VisualShaderNodeInput_g1vxb 8      )   local://VisualShaderNodeExpression_pe8dn m      $   local://VisualShaderNodeInput_8pxvy �      ,   local://VisualShaderNodeFloatConstant_0wk61       ,   res://shaders/player/player_invincible.tres T         VisualShaderNodeInput             color          VisualShaderNodeInput             uv          VisualShaderNodeExpression       
     Dͬ�C	      /   res = sin(t * mul + col) * cos(t * mul + col);          VisualShaderNodeInput             time          VisualShaderNodeFloatConstant    
         A         VisualShader          �  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:3
	vec2 n_out3p0 = UV;


// Input:2
	vec4 n_out2p0 = COLOR;


// Input:5
	float n_out5p0 = TIME;


// FloatConstant:6
	float n_out6p0 = 10.000000;


	vec3 n_out4p0;
// Expression:4
	n_out4p0 = vec3(0.0, 0.0, 0.0);
	{
		n_out4p0 = sin(vec3(n_out5p0) * n_out6p0 + vec3(n_out2p0.xyz)) * cos(vec3(n_out5p0) * n_out6p0 + vec3(n_out2p0.xyz));
	}


// Output:0
	COLOR.rgb = n_out4p0;


}
                       
     4D  pB                
     ��   C               
     ��  pB               
      B  �B   
     Dͬ�C         0,4,u;1,4,col;2,4,t;3,0,mul;       	   0,4,res;       /   res = sin(t * mul + col) * cos(t * mul + col);              !   
     ��  �C"            #   
     p�  �C$                                                                                    RSRC
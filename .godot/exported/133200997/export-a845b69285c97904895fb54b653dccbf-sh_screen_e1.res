RSRC                    VisualShader            ��������                                            2      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    op_type 	   operator    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_lxq7d �      '   local://VisualShaderNodeVectorOp_6py7f 3      '   local://VisualShaderNodeVectorOp_jlw2t �      $   local://VisualShaderNodeInput_2qofh       $   local://VisualShaderNodeInput_wy66f a      &   local://VisualShaderNodeFresnel_og7vy �      &   local://VisualShaderNodeColorOp_imook �         local://VisualShader_wxo5f !	         VisualShaderNodeInput          
   screen_uv          VisualShaderNodeVectorOp                    
                 
     �A  A                            VisualShaderNodeVectorOp                    
                 
     �A  0A                            VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeInput             color          VisualShaderNodeFresnel                                    �?         VisualShaderNodeColorOp                      VisualShader    	      H  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:6
	vec4 n_out6p0 = COLOR;


// Input:2
	vec2 n_out2p0 = SCREEN_UV;


// Input:5
	vec2 n_out5p0 = SCREEN_PIXEL_SIZE;


// VectorOp:4
	vec2 n_in4p1 = vec2(20.00000, 11.00000);
	vec2 n_out4p0 = n_out5p0 * n_in4p1;


// VectorOp:3
	vec2 n_out3p0 = n_out2p0 / n_out4p0;


// Fresnel:7
	float n_in7p3 = 1.00000;
	float n_out7p0 = pow(clamp(dot(NORMAL, vec3(n_out3p0, 0.0)), 0.0, 1.0), n_in7p3);


// ColorOp:8
	vec3 n_out8p0 = abs(vec3(n_out6p0.xyz) - vec3(n_out7p0));


// Output:0
	COLOR.rgb = n_out8p0;


}
                       
     D  pB                
     �  �B               
     ��  �B               
     ��  4C               
     9�  4C               
     ��  �A               
     ��   C                
     �C  �B!                                                                                                                RSRC
RSRC                    VisualShader            ��������                                            F      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    op_type 	   operator 	   constant    size    expression    type 	   function 
   condition    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/20/size    nodes/fragment/20/input_ports    nodes/fragment/20/output_ports    nodes/fragment/20/expression    nodes/fragment/21/node    nodes/fragment/21/position    nodes/fragment/22/node    nodes/fragment/22/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_xippk �	      $   local://VisualShaderNodeInput_x0hbk )
      '   local://VisualShaderNodeVectorOp_t1a5d a
      '   local://VisualShaderNodeVectorOp_k77rp �
      '   local://VisualShaderNodeVectorOp_mg7v8 K      '   local://VisualShaderNodeVectorOp_rwrm0 �      $   local://VisualShaderNodeInput_qdla7 5      $   local://VisualShaderNodeInput_ae1nj y      ,   local://VisualShaderNodeFloatConstant_bxe31 �      )   local://VisualShaderNodeExpression_r74if �      &   local://VisualShaderNodeCompare_l63bu j      '   local://VisualShaderNodeVectorOp_ms0ed �         local://VisualShader_r8ad7          VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                                  VisualShaderNodeVectorOp                                            ���=���=���=                  VisualShaderNodeVectorOp                    
                 
     �A  A                            VisualShaderNodeVectorOp                    
                 
     HB  HB                            VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeInput             time          VisualShaderNodeFloatConstant    	      ��L=         VisualShaderNodeExpression    
   
    @$D ��C      9   res = pow(3.0, sin(tan(v.x) + tan(v.y)) + sin(t)) - 3.0;          VisualShaderNodeCompare                      VisualShaderNodeVectorOp                    
                 
      �   �                   VisualShader "         �  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:3
	vec4 n_out3p0 = COLOR;


// Input:2
	vec2 n_out2p0 = SCREEN_UV;


// VectorOp:22
	vec2 n_in22p1 = vec2(-0.50000, -0.50000);
	vec2 n_out22p0 = n_out2p0 + n_in22p1;


// Input:12
	vec2 n_out12p0 = SCREEN_PIXEL_SIZE;


// VectorOp:11
	vec2 n_in11p1 = vec2(50.00000, 50.00000);
	vec2 n_out11p0 = n_out12p0 * n_in11p1;


// VectorOp:10
	vec2 n_out10p0 = n_out22p0 / n_out11p0;


// Input:15
	float n_out15p0 = TIME;


	float n_out20p0;
// Expression:20
	n_out20p0 = 0.0;
	{
		n_out20p0 = pow(3.0, sin(tan(n_out10p0.x) + tan(n_out10p0.y)) + sin(n_out15p0)) - 3.0;
	}


// Compare:21
	float n_in21p1 = 0.00000;
	bool n_out21p0 = n_out20p0 >= n_in21p1;


// FloatConstant:19
	float n_out19p0 = 0.050000;


// VectorOp:5
	vec3 n_out5p0 = vec3(n_out21p0 ? 1.0 : 0.0) * vec3(n_out19p0);


// VectorOp:4
	vec4 n_out4p0 = n_out3p0 + vec4(n_out5p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out4p0.xyz);


}
                       
    ��D  �B                
     H�   C               
     �  ��               
    ��D  �B                
    ��D  HC!            "   
     ��  4C#            $   
     ��  pC%            &   
     >�  pC'            (   
     �  �C)            *   
     fD  �C+         	   ,   
     �B  4C-   
    @$D ��C.         0,3,v;1,0,t; /      	   0,0,res; 0      9   res = pow(3.0, sin(tan(v.x) + tan(v.y)) + sin(t)) - 3.0; 1         
   2   
     RD  HC3            4   
     ��  �B5       0                                     
                                                                                         
                     
                           RSRC
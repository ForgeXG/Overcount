RSRC                    VisualShader            ��������                                            L      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    type 	   function 
   condition    op_type 	   operator 	   constant    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/16/node    nodes/fragment/16/position    nodes/fragment/17/node    nodes/fragment/17/position    nodes/fragment/18/node    nodes/fragment/18/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/21/node    nodes/fragment/21/position    nodes/fragment/22/node    nodes/fragment/22/position    nodes/fragment/23/node    nodes/fragment/23/position    nodes/fragment/24/node    nodes/fragment/24/position    nodes/fragment/26/node    nodes/fragment/26/position    nodes/fragment/27/node    nodes/fragment/27/position    nodes/fragment/28/node    nodes/fragment/28/position    nodes/fragment/29/node    nodes/fragment/29/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_e5675 �      $   local://VisualShaderNodeInput_0q7cu -      &   local://VisualShaderNodeCompare_uxil5 e      .   local://VisualShaderNodeVectorDecompose_3nxib �      '   local://VisualShaderNodeVectorOp_fwm1i 5      '   local://VisualShaderNodeVectorOp_geakm �      &   local://VisualShaderNodeFloatOp_xcq8l       (   local://VisualShaderNodeFloatFunc_k3c27 G      (   local://VisualShaderNodeFloatFunc_rxa3g }      '   local://VisualShaderNodeVectorOp_ihsn1 �      $   local://VisualShaderNodeInput_hgkj0 (      '   local://VisualShaderNodeVectorOp_vsfrb l      $   local://VisualShaderNodeInput_wsgr8 �      '   local://VisualShaderNodeVectorOp_crop3       ,   local://VisualShaderNodeVectorCompose_igjec �      (   local://VisualShaderNodeFloatFunc_royvd �      (   local://VisualShaderNodeFloatFunc_6ovtm �      ,   local://VisualShaderNodeFloatConstant_ijim2 '         local://VisualShader_rkhch a         VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             color          VisualShaderNodeCompare                                              )   �������?                   VisualShaderNodeVectorDecompose                    
           
                   VisualShaderNodeVectorOp                                                                
                  VisualShaderNodeVectorOp                                            ���=���=���=                  VisualShaderNodeFloatOp             VisualShaderNodeFloatFunc                       VisualShaderNodeFloatFunc                       VisualShaderNodeVectorOp                    
                 
     �A  A
                            VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeVectorOp                    
                 
     4B  4B
                            VisualShaderNodeInput             time          VisualShaderNodeVectorOp                    
                 
           
                   VisualShaderNodeVectorCompose    
                   VisualShaderNodeFloatFunc                      VisualShaderNodeFloatFunc                       VisualShaderNodeFloatConstant          ��L=         VisualShader *         �  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:8
	vec4 n_out8p0 = COLOR;


// Input:2
	vec2 n_out2p0 = SCREEN_UV;


// Input:21
	vec2 n_out21p0 = SCREEN_PIXEL_SIZE;


// VectorOp:22
	vec2 n_in22p1 = vec2(45.00000, 45.00000);
	vec2 n_out22p0 = n_out21p0 * n_in22p1;


// VectorOp:20
	vec2 n_out20p0 = n_out2p0 / n_out22p0;


// Input:23
	float n_out23p0 = TIME;


// FloatFunc:27
	float n_out27p0 = cos(n_out23p0);


// FloatFunc:28
	float n_out28p0 = sin(n_out23p0);


// VectorCompose:26
	vec2 n_out26p0 = vec2(n_out27p0, n_out28p0);


// VectorOp:24
	vec2 n_out24p0 = n_out20p0 + n_out26p0;


// VectorDecompose:10
	float n_out10p0 = n_out24p0.x;
	float n_out10p1 = n_out24p0.y;


// FloatFunc:18
	float n_out18p0 = sin(n_out10p0);


// FloatFunc:19
	float n_out19p0 = sin(n_out10p1);


// FloatOp:17
	float n_out17p0 = n_out18p0 + n_out19p0;


// Compare:9
	float n_in9p1 = 0.00000;
	bool n_out9p0 = n_out17p0 > n_in9p1;


// FloatConstant:29
	float n_out29p0 = 0.050000;


// VectorOp:16
	vec3 n_out16p0 = vec3(n_out9p0 ? 1.0 : 0.0) * vec3(n_out29p0);


// VectorOp:15
	vec4 n_out15p0 = n_out8p0 + vec4(n_out16p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out15p0.xyz);


}
                       
     �D  �B                
      �   C               
      �  pB               
    ��D  HC               
     MD  4C                
    ��D  �B!            "   
    ��D  HC#            $   
    ��D  HC%            &   
     �D  HC'            (   
     �D  �C)         	   *   
     4C  4C+         
   ,   
     ��  pC-            .   
         pC/            0   
     4�  �C1            2   
     D  C3            4   
   sH�C���C5            6   
     HC  �C7            8   
     HC  �C9            :   
     �D  �C;       P                                             	              
                                               	       
                                                              
                                                                                                            RSRC
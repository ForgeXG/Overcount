RSRC                    VisualShader            ��������                                            <      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    size    expression    op_type 	   operator    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/4/size    nodes/fragment/4/input_ports    nodes/fragment/4/output_ports    nodes/fragment/4/expression    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections     
   $   local://VisualShaderNodeInput_bwyok g      $   local://VisualShaderNodeInput_i6ay7 �      )   local://VisualShaderNodeExpression_tlq5l �      $   local://VisualShaderNodeInput_na4ts �	      '   local://VisualShaderNodeVectorOp_bsf2s �	      $   local://VisualShaderNodeInput_7t3c8 
      '   local://VisualShaderNodeVectorOp_jxikd G
      '   local://VisualShaderNodeVectorOp_vya0q �
      '   local://VisualShaderNodeVectorOp_2cvlv 1         local://VisualShader_ftgqw �         VisualShaderNodeInput             time          VisualShaderNodeInput                    
   screen_uv          VisualShaderNodeExpression       
   �
D{T�C      u   res = vec3(0.0, ceil(sin(sqrt(v.x * v.x + v.y * v.y) + t)) * 0.2, ceil(sin(sqrt(v.x * v.x + v.y * v.y) + t)) * 0.5);          VisualShaderNodeInput             color          VisualShaderNodeVectorOp             VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeVectorOp                    
                 
     �?  �?	          
                  VisualShaderNodeVectorOp                    
                 
           	          
                  VisualShaderNodeVectorOp                    
                 
      �   �	                   VisualShader          ^  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:5
	vec4 n_out5p0 = COLOR;


// Input:3
	vec2 n_out3p0 = SCREEN_UV;


// VectorOp:11
	vec2 n_in11p1 = vec2(-0.50000, -0.50000);
	vec2 n_out11p0 = n_out3p0 + n_in11p1;


// Input:8
	vec2 n_out8p0 = SCREEN_PIXEL_SIZE;


// VectorOp:9
	vec2 n_in9p1 = vec2(1.00000, 1.00000);
	vec2 n_out9p0 = n_out8p0 * n_in9p1;


// VectorOp:10
	vec2 n_out10p0 = n_out11p0 / n_out9p0;


// Input:2
	float n_out2p0 = TIME;


	vec3 n_out4p0;
// Expression:4
	n_out4p0 = vec3(0.0, 0.0, 0.0);
	{
		n_out4p0 = vec3(0.0, ceil(sin(sqrt(n_out10p0.x * n_out10p0.x + n_out10p0.y * n_out10p0.y) + n_out2p0)) * 0.2, ceil(sin(sqrt(n_out10p0.x * n_out10p0.x + n_out10p0.y * n_out10p0.y) + n_out2p0)) * 0.5);
	}


// VectorOp:6
	vec3 n_out6p0 = vec3(n_out5p0.xyz) + n_out4p0;


// Output:0
	COLOR.rgb = n_out6p0;


}
                       
     CD  C                
     �  �C               
     ��  ��               
      �   C   
   �
D{T�C         0,3,v;1,0,t;       	   0,4,res;       u   res = vec3(0.0, ceil(sin(sqrt(v.x * v.x + v.y * v.y) + t)) * 0.2, ceil(sin(sqrt(v.x * v.x + v.y * v.y) + t)) * 0.5);                 
   io�AB~�B!            "   
     D  C#            $   
     ��  pC%            &   
     H�  pC'            (   
     ��  �B)            *   
     /�   B+       $                                     	       	       
      
                                                 
                           RSRC
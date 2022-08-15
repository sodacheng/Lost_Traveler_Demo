// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LT/Trail"
{
	Properties
	{
		[HDR]_Color1("Color 0", Color) = (0.7538033,0,1,1)
		[HDR]_Color3("Color 2", Color) = (0,0.2465775,1,1)
		_ColorRotio("ColorRotio", Range( -1 , 1)) = -0.34
		_TrailTexc("TrailTexc", 2D) = "white" {}
		_TexSpeed1("TexSpeed", Vector) = (-0.1,0,0,0)
		_DissloveSpeed1("DissloveSpeed", Vector) = (-1,0,0,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_TrailLength("TrailLength", Range( 0 , 1)) = 0.09

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color1;
			uniform float4 _Color3;
			uniform float _ColorRotio;
			uniform sampler2D _NoiseTex;
			uniform float2 _DissloveSpeed1;
			uniform float4 _NoiseTex_ST;
			uniform float _TrailLength;
			uniform sampler2D _TrailTexc;
			uniform float2 _TexSpeed1;
			uniform float4 _TrailTexc_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord20 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult17 = lerp( _Color1 , _Color3 , saturate( ( texCoord20.x + _ColorRotio ) ));
				float2 appendResult2 = (float2(_DissloveSpeed1.x , _DissloveSpeed1.y));
				float2 uv_NoiseTex = i.ase_texcoord1.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float2 panner6 = ( 1.0 * _Time.y * appendResult2 + uv_NoiseTex);
				float2 texCoord4 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult8 = (float2(_TexSpeed1.x , _TexSpeed1.y));
				float2 uv_TrailTexc = i.ase_texcoord1.xy * _TrailTexc_ST.xy + _TrailTexc_ST.zw;
				float2 panner12 = ( 1.0 * _Time.y * appendResult8 + uv_TrailTexc);
				float temp_output_15_0 = ( saturate( ( ( tex2D( _NoiseTex, panner6 ).r + ( 1.0 - texCoord4.x ) ) - ( texCoord4.x + (0.5 + (_TrailLength - 0.0) * (-0.5 - 0.5) / (1.0 - 0.0)) ) ) ) * tex2D( _TrailTexc, panner12 ).r );
				float4 appendResult24 = (float4((( lerpResult17 * temp_output_15_0 )).rgb , ( _Color1.a * _Color3.a * saturate( temp_output_15_0 ) )));
				
				
				finalColor = appendResult24;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
7;12;1906;1007;1526.963;-202.8307;1;True;False
Node;AmplifyShaderEditor.Vector2Node;1;-1352.43,87.06951;Inherit;False;Property;_DissloveSpeed1;DissloveSpeed;5;0;Create;True;0;0;0;False;0;False;-1,0;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1324.618,-202.7693;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;2;-1116.375,63.87762;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-863.8348,231.33;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-1010.022,404.724;Inherit;False;Property;_TrailLength;TrailLength;7;0;Create;True;0;0;0;False;0;False;0.09;0.751;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-887.3749,-97.12239;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-684.2733,385.6848;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-988.8783,839.6763;Inherit;False;Property;_TexSpeed1;TexSpeed;4;0;Create;True;0;0;0;False;0;False;-0.1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;9;-616.5428,-95.54109;Inherit;True;Property;_NoiseTex;NoiseTex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;7;-514.975,156.8764;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-559.0159,-1030.4;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-613.2819,-849.832;Inherit;False;Property;_ColorRotio;ColorRotio;2;0;Create;True;0;0;0;False;0;False;-0.34;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-706.9953,853.6887;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-414.8676,321.815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-302.522,31.19197;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-883.4073,670.2986;Inherit;False;0;13;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;12;-531.5546,719.0424;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-148.8941,91.54162;Inherit;False;2;0;FLOAT;0.73;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-252.3845,-968.9257;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-245.7782,570.0413;Inherit;True;Property;_TrailTexc;TrailTexc;3;0;Create;True;0;0;0;False;0;False;-1;None;22fc0a62e2d6db945a20f9fbf5c77d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;27;-5.201334,-939.6812;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-204.5678,-634.552;Inherit;False;Property;_Color1;Color 0;0;1;[HDR];Create;True;0;0;0;False;0;False;0.7538033,0,1,1;0.7538033,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;32;24.83103,56.43713;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-185.0409,-395.6184;Inherit;False;Property;_Color3;Color 2;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0.2465775,1,1;0,1.141245,2.270603,0.4901961;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;293.6306,-17.27991;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;217.9258,-705.576;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;548.2308,-664.5035;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;22;689.238,-46.68871;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;898.0541,-161.9734;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;903.9409,-641.2686;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;1175.325,-268.127;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1500.974,-323.8218;Float;False;True;-1;2;ASEMaterialInspector;100;1;LT/Trail;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;2
WireConnection;6;0;3;0
WireConnection;6;2;2;0
WireConnection;33;0;29;0
WireConnection;9;1;6;0
WireConnection;7;0;4;1
WireConnection;8;0;5;1
WireConnection;8;1;5;2
WireConnection;28;0;4;1
WireConnection;28;1;33;0
WireConnection;11;0;9;1
WireConnection;11;1;7;0
WireConnection;12;0;10;0
WireConnection;12;2;8;0
WireConnection;14;0;11;0
WireConnection;14;1;28;0
WireConnection;25;0;20;1
WireConnection;25;1;26;0
WireConnection;13;1;12;0
WireConnection;27;0;25;0
WireConnection;32;0;14;0
WireConnection;15;0;32;0
WireConnection;15;1;13;1
WireConnection;17;0;16;0
WireConnection;17;1;19;0
WireConnection;17;2;27;0
WireConnection;18;0;17;0
WireConnection;18;1;15;0
WireConnection;22;0;15;0
WireConnection;36;0;16;4
WireConnection;36;1;19;4
WireConnection;36;2;22;0
WireConnection;23;0;18;0
WireConnection;24;0;23;0
WireConnection;24;3;36;0
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=950C8D64A3B5DAB88E37DFE184B5FD3E635A2954
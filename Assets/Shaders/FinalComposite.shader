Shader "Hidden/FinalComposite"
{
    CGINCLUDE
    float _XScale;
    float _YScale;
    ENDCG
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * float2(_XScale, _YScale);
                return o;
            }

            sampler2D _GAlbedo;
            sampler2D _GNormal;
            sampler2D _GPosition;
            
            sampler2D _AmbientOcclusion;
            sampler2D _ReflectionTexture;
            float4x4 _ViewMatrix;

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = 0;
                float4 albedo = tex2D(_GAlbedo, i.uv);
                col.rgb = albedo.rgb;
                float ssao = tex2D(_AmbientOcclusion, i.uv).r;
                col *= ssao;
                col.a = 1;
                return col;
                /*
                float3 reflection = tex2D(_ReflectionTexture, i.uv).rgb;
                //return float4(reflection, 1);
                col = lerp(col, tex2D(_GAlbedo, reflection.xy), albedo.a * reflection.z);
                return float4(col, 1);
                return ssao;
                */
            }
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;// * float2(_XScale, 1);
                return o;
            }

            sampler2D _MainTex;
            sampler2D _GAlbedo;
            sampler2D _GNormal;
            sampler2D _GPosition;
            
            sampler2D _AmbientOcclusion;
            sampler2D _ReflectionTexture;
            float4x4 _ViewMatrix;

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float3 reflection = tex2D(_ReflectionTexture, i.uv * float2(_XScale,_YScale)).rgb;
                //return float4(reflection,1);
                //return float4(reflection, 1);
                col.rgb = lerp(col.rgb, tex2D(_MainTex, reflection.xy * float2(1/_XScale,1/_YScale)).rgb, reflection.z);
                return col;
            }
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _GAlbedo;
            sampler2D _GNormal;
            sampler2D _GPosition;
            
            sampler2D _AmbientOcclusion;
            sampler2D _ReflectionTexture;
            float4x4 _ViewMatrix;


            fixed4 frag (v2f i) : SV_Target
            {
                //float4 col = tex2D(_GAlbedo, i.uv * float2(_XScale, _YScale));
                float4 col = tex2D(_AmbientOcclusion, i.uv * float2(_XScale, _YScale));
                return col;
            }
            ENDCG
        }
    }
}

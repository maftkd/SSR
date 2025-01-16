Shader "Hidden/Blur"
{
    CGINCLUDE
    float _Radius;
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
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            fixed4 frag (v2f i) : SV_Target
            {
                float col = 0;
                float samples = 0;
                for(int y = -_Radius; y <= _Radius; y++)
                {
                    col += tex2D(_MainTex, i.uv + float2(0, y) * _MainTex_TexelSize.xy).r;
                    samples++;
                }
                return col / samples;
                return col / samples;
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
            float4 _MainTex_TexelSize;

            fixed4 frag (v2f i) : SV_Target
            {
                float col = 0;
                float samples = 0;
                for(int x = -_Radius; x <= _Radius; x++)
                {
                    col += tex2D(_MainTex, i.uv + float2(x, 0) * _MainTex_TexelSize.xy).r;
                    samples++;
                }
                //return samples / 5;
                return col / samples;
            }
            ENDCG
        }
    }
}

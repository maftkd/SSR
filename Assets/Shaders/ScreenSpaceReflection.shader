Shader "Hidden/ScreenSpaceReflection"
{
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

            sampler2D _GAlbedo;
            sampler2D _GNormal;
            sampler2D _GPosition;

            float _MaxDistance;
            float _Resolution;
            int _Steps;
            float _Thickness;
            float _Noise;
            
            float4x4 _ProjectionMatrix;

            float2 viewSpacePosToUvCoords(float3 pos)
            {
                float4 coords = float4(pos, 1);
                coords = mul(_ProjectionMatrix, coords);
                coords.xyz /= coords.w;
                coords.xy = coords.xy * 0.5 + 0.5;
                return coords.xy;
            }

            float random(inout uint state)
            {
                state = state * 747796405u + 2891336453u;
                uint result = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
                result = (result >> 22u) ^ result;
                return result / 4294967296.0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 albedo = tex2D(_GAlbedo, i.uv);
                if(albedo.a < 0.5)
                {
                     return 0;
                }
                
                uint2 pixCoords = i.uv * _ScreenParams.xy;
                uint pixIndex = pixCoords.y * _ScreenParams.x + pixCoords.x;
                uint rngState = pixIndex;// + _AccumulationFrames * 719393;

                float4 positionFrom = tex2D(_GPosition, i.uv);
                float3 unitPositionFrom = normalize(positionFrom.xyz);
                float3 normal = normalize(tex2D(_GNormal, i.uv).xyz);
                float3 reflectedRay = normalize(reflect(unitPositionFrom, normal));
                positionFrom.xyz += normal * random(rngState) * _Noise * 100;

                float4 startView = float4(positionFrom + reflectedRay * 0.0, 1);
                float4 endView = float4(positionFrom + reflectedRay * _MaxDistance, 1);

                float2 startFrag = i.uv;
                float2 endFrag = viewSpacePosToUvCoords(endView.xyz);
                //return tex2D(_GAlbedo, endFrag);

                //float2 screenSpaceRay = endFrag - startFrag;
                //float deltaX = screenSpaceRay.x;
                //float deltaY = screenSpaceRay.y;
                //float useX = abs(deltaX) >= abs(deltaY) ? 1 : 0;
                //float delta = lerp(abs(deltaY), abs(deltaX), useX) * _Resolution;
                //float2 increment = screenSpaceRay / delta;

                float search0 = 0;
                float search1 = 0;

                float hit0 = 0;
                float hit1 = 0;

                float viewDistance = startView.z;

                float2 curCoords = startFrag;
                float4 positionTo = 0;
                float depthDifference = 0;
                int steps = 64;
                for(float t = 1; t <= steps; t++)
                {
                    search1 = t / steps;
                    search1 *= search1;
                    //t += (random(rngState) - 0.5) * _Noise * 0.01;
                    curCoords = lerp(startFrag, endFrag, search1);// + float2(random(rngState) - 0.5, random(rngState) - 0.5) * _Noise * 0.01; 
                    
                    positionTo = tex2D(_GPosition, curCoords);

                    //viewDistance = lerp(startView.z, endView.z, search1);
                    //perspective-correct interpolation
                    viewDistance = (startView.z * endView.z) / lerp(endView.z, startView.z, search1);

                    depthDifference = viewDistance - positionTo.z;

                    if(depthDifference < 0 && depthDifference > -_Thickness)
                    {
                        hit0 = 1;
                        break;
                    }
                    else
                    {
                        search0 = search1;
                    }
                }

                /*
                if(hit0 == 0)
                {
                    return 0;
                }
                else
                {
                    return float4(curCoords, 0, 1);
                }
                */

                float2 diffFromCenter = float2(0.5,0.5) - curCoords.xy;
                float distFromCenter = length(diffFromCenter);
                float visibility = hit0 *
                    //(1 - max(0, dot(-unitPositionFrom, reflectedRay))) *
                        //(1 - saturate(depthDifference / _Thickness)) *
                            (1 - saturate(length(positionTo.xyz - positionFrom.xyz) / _MaxDistance)) *
                                smoothstep(0.7, 0.5, distFromCenter);
                                    //step(dot(tex2D(_GNormal, curCoords).xyz, reflectedRay), 0);

                return float4(curCoords.xy, visibility, 1);

                /*
                //return hit0;
                search1 = search0 + (search1 - search0) * 0.5;

                //refine loop
                steps = 32;
                for(float t = 1; t <= steps; t++)
                {
                    //search1 = t / steps;
                    curCoords = lerp(startFrag, endFrag, search1);
                    
                    float4 positionTo = tex2D(_GPosition, curCoords);

                    //viewDistance = lerp(startView.z, endView.z, search1);
                    //perspective-correct interpolation
                    viewDistance = (startView.z * endView.z) / lerp(endView.z, startView.z, search1);

                    float depthDistance = viewDistance - positionTo.z;

                    if(depthDistance < 0 && depthDistance > -_Thickness)
                    {
                        hit1 = 1;
                        search1 = search0 + (search0 - search1) * 0.5;
                    }
                    else
                    {
                        float tmp = search1;
                        search1 = search1 + (search1 - search0) * 0.5;
                        search0 = tmp;
                    }
                }

                if(hit1 > 0.5)
                {
                    return float4(curCoords, 0, 1);
                }
                return 0;
                */
                
                return albedo;
            }
            ENDCG
        }
    }
}

Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _t ("t", Range(0, 1)) = 1.0
        _t2 ("t2", Range(0, 1)) = 1.0
        _Near ("Near", float) = 1.0
        _Far ("Far", float) = 2.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Standard fullforwardshadows addshadow vertex:vert
        #pragma target 3.0

        float _t, _t2, _t3, _t4, _Near, _Far;
        float4x4 _View, _IView;

        void vert (inout appdata_full v)
        {
            float n = _Near;
            float f = _Far;
            float4x4 zreverse = float4x4(1, 0, 0, 0,
                                          0, 1, 0, 0,
                                          0, 0, -1, 0,
                                          0, 0, 0, 1);
            float4x4 indentity = float4x4(1, 0, 0, 0,
                                          0, 1, 0, 0,
                                          0, 0, 1, 0,
                                          0, 0, 0, 1);
            float4x4 project = float4x4(n, 0, 0, 0,
                                        0, n, 0, 0,
                                        0, 0, n+f, n*f,
                                        0, 0, -1, 0);
                                        
            float4x4 squish = float4x4(1, 0, 0, 0,
                                       0, 1, 0, 0,
                                       0, 0, 0, 0,
                                       0, 0, 0, 1);

            float4x4 nvv = float4x4(1, 0, 0, 0,
                                    0, 1, 0, 0,
                                    0, 0, 1, 0.5*(n+f),
                                    0, 0, 0, 1);

            float4x4 iview_t = lerp(_IView, zreverse, _t);
            float4x4 project_t = lerp(indentity, project, _t2);
            float4x4 nvv_t = lerp(indentity, nvv, _t3);
            float4x4 squish_t = lerp(indentity, squish, _t4);

            v.vertex = mul(mul(_View, UNITY_MATRIX_M), v.vertex);
            v.vertex = mul(mul(squish_t, mul(nvv_t, project_t)), v.vertex);
            v.vertex = mul(mul(unity_WorldToObject, iview_t), v.vertex);
            v.vertex.xyz /= v.vertex.w;
        }

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

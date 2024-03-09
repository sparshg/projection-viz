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

        float _t, _t2, _Near, _Far;
        float4x4 _View, _IView;
        
        void vert (inout appdata_full v)
        {
            float n = _Near;
            float f = _Far;
            float4x4 transf = float4x4(n, 0, 0, 0,
                                        0, n, 0, 0,
                                        0, 0, n+f, -n*f,
                                        0, 0, 1, 0);
            float4x4 scale = float4x4(1, 0, 0, 0,
                                        0, 1, 0, 0,
                                        0, 0, -1, 0,
                                        0, 0, 0, 1);
                                        
            float4x4 z = float4x4(1, 0, 0, 0,
                                  0, 1, 0, 0,
                                  0, 0, 0, n,
                                  0, 0, 0, 1);
    
            float4 newv = mul(mul(_View, UNITY_MATRIX_M), v.vertex);
            newv = mul(mul(mul(scale, lerp(transf, mul(z, transf), _t2)), scale), newv);
            // newv = mul(transf, newv);
            newv = mul(mul(unity_WorldToObject, _IView), newv);
            newv.xyz /= newv.w;
            v.vertex = lerp(v.vertex, newv, _t);
            // UNITY_MATRIX_I_M;
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

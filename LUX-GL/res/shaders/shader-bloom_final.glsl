#shader vertex
#version 450 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoords;

out vec2 TexCoords;

void main()
{
    TexCoords = aTexCoords;
    gl_Position = vec4(aPos, 1.0);
}



#shader fragment
#version 450 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D scene;
uniform sampler2D bloomBlur;

uniform bool bloom;
uniform float exposure;

void main()
{             
    //const float gamma = 2.2;
    vec3 hdrColor = texture(scene, TexCoords).rgb;      
    vec3 bloomColor = texture(bloomBlur, TexCoords).rgb;
    vec3 result = hdrColor;
    //float brightness = dot(FragColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    if (bloom && length(bloomColor) > 0)
    {
        hdrColor += bloomColor; // additive blending
        // tone mapping
        result = vec3(1.0) - exp(-hdrColor * exposure);
    }
    //vec3 result = hdrColor;
    // also gamma correct while we're at it       
    //result = pow(result, vec3(1.0 / gamma));
    FragColor = vec4(result, 1.0);
}




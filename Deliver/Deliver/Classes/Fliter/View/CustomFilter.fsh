varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main()
{
    
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    lowp vec4 outputColor;
    outputColor.r = (textureColor.r * 0.393) + (textureColor.g * 0.769) + (textureColor.b * 0.189);
    outputColor.g = (textureColor.r * 0.349) + (textureColor.g * 0.686) + (textureColor.b * 0.168);
    outputColor.b = (textureColor.r * 0.272) + (textureColor.g * 0.534) + (textureColor.b * 0.131);
    outputColor.a = 1.0;
    
    gl_FragColor = outputColor;
//    lowp vec3 tc = vec3(1.0, 0.0, 0.0);
//
//    lowp vec3 pixcol = texture2D(inputImageTexture, textureCoordinate).rgb;
//    lowp vec3 colors[3];
//    colors[0] = vec3(0.0, 0.0, 1.0);
//    colors[1] = vec3(1.0, 1.0, 0.0);
//    colors[2] = vec3(1.0, 0.0, 0.0);
//    mediump float lum = (pixcol.r + pixcol.g + pixcol.b) / 3.0;
//    int ix = (lum < 0.5)? 0:1;
//    tc = mix(colors[ix], colors[ix + 1], (lum - float(ix) * 0.5) / 0.5);
//
//    gl_FragColor = vec4(tc, 1.0);
}
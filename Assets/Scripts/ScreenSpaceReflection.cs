using UnityEngine;

public class ScreenSpaceReflection : MonoBehaviour, IPostProcessLayer
{
    public Shader shader;
    private Material _mat;
    private RenderTexture _reflectionTexture;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (_mat == null)
        {
            _mat = new Material(shader);
        }
        if(_reflectionTexture == null || _reflectionTexture.width != dest.width || _reflectionTexture.height != dest.height)
        {
            if (_reflectionTexture != null)
            {
                _reflectionTexture.Release();
            }
            _reflectionTexture = new RenderTexture(dest.width, dest.height, 0, RenderTextureFormat.ARGB32);
            _reflectionTexture.wrapMode = TextureWrapMode.Clamp;
            Shader.SetGlobalTexture("_ReflectionTexture", _reflectionTexture);
        }
        
        Graphics.Blit(null, _reflectionTexture, _mat);
    }
}

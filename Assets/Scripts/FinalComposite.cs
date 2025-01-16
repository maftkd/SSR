using UnityEngine;

public class FinalComposite : MonoBehaviour, IPostProcessLayer
{
    public Shader finalComposite;
    private Material _finalCompositeMat;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_finalCompositeMat == null)
        {
            _finalCompositeMat = new Material(finalComposite);
        }
        
        Graphics.Blit(null, destination, _finalCompositeMat);
    }
}

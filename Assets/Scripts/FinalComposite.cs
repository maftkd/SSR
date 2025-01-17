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

        RenderTexture tmp = new RenderTexture(destination.width, destination.height, 0, destination.format);
        Graphics.Blit(null, tmp, _finalCompositeMat, 0);
        
        //Graphics.Blit(null, destination, _finalCompositeMat);
        Graphics.Blit(tmp, destination, _finalCompositeMat, 1);
    }
}

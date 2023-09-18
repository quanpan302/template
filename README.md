ProjectName

# Datasets

## image

```markdown
![alt text](./sub%20folder/image.jpg)
```

## matplotlib

```python
# row: 3
# col: 2
# axs[0, 0] to axs[2, 1]
fig, axs = plt.subplots(3, 2, figsize=(15, 7))

# row: 1
# col: 1
fig, ax = plt.subplots(figsize=(15, 7))

# set layout, save and close figure
plt.tight_layout(rect=[0, 0, 1, 0.95])
# plt.savefig(file_fig, dpi=600, bbox_inches="tight")
plt.savefig(file_fig, dpi=600)
plt.close()
```

## plotly engine

### kaleido==0.1.0post1

```shell
pip install kaleido==0.1.0post1
```

```python
import plotly.graph_objects as go
import numpy as np
import plotly.io as pio
np.random.seed(1)

N = 100
x = np.random.rand(N)
y = np.random.rand(N)
colors = np.random.rand(N)
sz = np.random.rand(N) * 30

fig = go.Figure()
fig.add_trace(go.Scatter(
    x=x,
    y=y,
    mode="markers",
    marker=go.scatter.Marker(
        size=sz,
        color=colors,
        opacity=0.6,
        colorscale="Viridis"
    )
))

fig.write_image('test.png')
```

### kaleido==0.2.1

**Not working**, [write_image hangs](https://github.com/plotly/Kaleido/issues/110)

```python
import plotly.io as pio
print(' '.join(pio.kaleido.scope._build_proc_args()))
```

```shell
C:\Anaconda3\envs\midas\lib\site-packages\kaleido\executable\kaleido.cmd plotly --plotlyjs='C:\\Anaconda3\\envs\\midas\\lib\\site-packages\\plotly\\package_data\\plotly.min.js' --mathjax='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js' --disable-gpu --allow-file-access-from-files --disable-breakpad --disable-dev-shm-usage --no-sandbox

{"data":{"layout": {}}, "format":"svg"}

[0922/185509.685:WARNING:resource_bundle.cc(405)] locale_file_path.empty() for locale
[0922/185509.743:WARNING:headless_browser_main_parts.cc(83)] Cannot create Pref Service with no user data dir.
{"code": 0, "message": "Success", "result": null, "version": "0.2.1"}
[0922/185510.510:ERROR:gpu_init.cc(430)] Passthrough is not supported, GL is swiftshader
```

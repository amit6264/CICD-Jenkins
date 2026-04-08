<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GitHub Actions Architecture</title>
<style>
  *{margin:0;padding:0;box-sizing:border-box}
  body{font-family:'Segoe UI',system-ui,sans-serif;background:#0d1117;color:#e6edf3;line-height:1.7;font-size:15px}
  .container{max-width:960px;margin:0 auto;padding:2rem 1.5rem}

  .hero{border-bottom:1px solid #21262d;padding:2rem 0 1.8rem;margin-bottom:2rem}
  .hero h1{font-size:1.9rem;font-weight:600;color:#f0f6fc}
  .hero p{color:#8b949e;margin-top:.4rem;font-size:.93rem}

  section{margin-bottom:2.2rem}
  h2{font-size:1.15rem;font-weight:600;color:#f0f6fc;padding-bottom:.5rem;border-bottom:1px solid #21262d;margin-bottom:1rem;display:flex;align-items:center;gap:.45rem}
  h3{font-size:.93rem;font-weight:600;color:#c9d1d9;margin:1rem 0 .45rem;display:flex;align-items:center;gap:.4rem}
  p{color:#c9d1d9;margin-bottom:.7rem;font-size:.92rem}
  strong{color:#f0f6fc}
  ul{list-style:none;display:flex;flex-direction:column;gap:.4rem;margin:.4rem 0 .4rem .2rem}
  ul li{display:flex;align-items:flex-start;gap:.55rem;font-size:.9rem;color:#c9d1d9}
  ul li::before{content:'';width:6px;height:6px;border-radius:50%;background:#30363d;flex-shrink:0;margin-top:.55rem}

  .callout{background:#161b22;border-left:3px solid #1f6feb;border-radius:0 6px 6px 0;padding:.65rem 1rem;margin:.7rem 0;font-size:.88rem;color:#8b949e}
  .callout strong{color:#58a6ff}

  .warn-box{background:#161b22;border:1px solid #9e6a03;border-radius:8px;padding:1rem 1.1rem;margin:.75rem 0}
  .warn-box h3{color:#e3b341;margin:0 0 .6rem;font-size:.93rem}
  .warn-row{display:flex;align-items:flex-start;gap:.5rem;font-size:.88rem;color:#c9d1d9;margin:.3rem 0}
  .warn-row .label{color:#8b949e;min-width:130px;font-weight:600}

  .runner-grid{display:grid;grid-template-columns:1fr 1fr;gap:.9rem;margin:.75rem 0}
  @media(max-width:580px){.runner-grid{grid-template-columns:1fr}}
  .runner-card{background:#161b22;border:1px solid #30363d;border-radius:9px;overflow:hidden}
  .runner-card-header{padding:.75rem 1rem;border-bottom:1px solid #30363d;display:flex;align-items:center;gap:.6rem}
  .runner-icon{width:32px;height:32px;border-radius:7px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0}
  .runner-card-header h4{font-size:.9rem;font-weight:600;color:#f0f6fc;margin:0}
  .runner-card-header span{font-size:.75rem;color:#8b949e}
  .runner-card-body{padding:.85rem 1rem}
  .runner-card-body ul li::before{background:#238636}
  .runner-card.self .runner-card-body ul li::before{background:#8957e5}

  .code-block{background:#161b22;border:1px solid #30363d;border-radius:8px;overflow:hidden;margin:.75rem 0}
  .code-header{background:#1c2128;border-bottom:1px solid #30363d;padding:.38rem 1rem;display:flex;align-items:center;justify-content:space-between}
  .code-header span{font-size:.74rem;color:#8b949e;font-family:'Courier New',monospace}
  .code-header button{background:none;border:1px solid #30363d;color:#8b949e;border-radius:4px;padding:2px 10px;font-size:.7rem;cursor:pointer;transition:all .2s}
  .code-header button:hover{border-color:#58a6ff;color:#58a6ff}
  pre{padding:.9rem 1rem;overflow-x:auto;font-family:'Courier New',monospace;font-size:.82rem;line-height:1.75;color:#e6edf3}
  .key{color:#7ee787}
  .str{color:#a5d6ff}
  .val{color:#79c0ff}
  .cmt{color:#8b949e;font-style:italic}
  .cmd{color:#ffa657}

  .flow-wrap{display:flex;flex-direction:column;align-items:center;gap:0;margin:1rem auto;max-width:360px}
  .flow-node{width:100%;display:flex;align-items:center;justify-content:center;border-radius:8px;padding:.58rem 1.2rem;font-size:.87rem;font-weight:600;text-align:center;border:1px solid #30363d;background:#161b22;color:#f0f6fc}
  .flow-node.trigger{border-color:#1f6feb;color:#58a6ff;background:#0a1628}
  .flow-node.workflow{border-color:#9e6a03;color:#e3b341;background:#1a1200}
  .flow-node.runner{border-color:#8957e5;color:#d2a8ff;background:#150d2e}
  .flow-node.exec{border-color:#238636;color:#56d364;background:#0a1f0e}
  .flow-node.output{border-color:#1f6feb;color:#58a6ff;background:#0a1628}
  .flow-arrow{color:#484f58;font-size:1rem;line-height:1;margin:4px 0}

  .steps-list{display:flex;flex-direction:column;gap:.55rem;margin:.75rem 0}
  .step-item{display:flex;align-items:flex-start;gap:.8rem;background:#161b22;border:1px solid #30363d;border-radius:7px;padding:.7rem .95rem}
  .step-num{background:#2d1f6e;color:#d2a8ff;border-radius:50%;width:24px;height:24px;display:flex;align-items:center;justify-content:center;font-size:.76rem;font-weight:700;flex-shrink:0;margin-top:1px}
  .step-content .step-title{font-weight:600;color:#f0f6fc;font-size:.88rem}
  .step-content .step-desc{color:#8b949e;font-size:.83rem;margin-top:1px}

  code{font-family:'Courier New',monospace;background:#21262d;color:#79c0ff;padding:2px 6px;border-radius:4px;font-size:.8rem;border:1px solid #30363d}

  hr{border:none;border-top:1px solid #21262d;margin:2rem 0}

  footer{border-top:1px solid #21262d;margin-top:3rem;padding-top:1.5rem;color:#484f58;font-size:.8rem;text-align:center}

  ::-webkit-scrollbar{height:6px;width:6px}
  ::-webkit-scrollbar-track{background:#0d1117}
  ::-webkit-scrollbar-thumb{background:#30363d;border-radius:3px}
</style>
</head>
<body>
<div class="container">

  <!-- Hero -->
  <div class="hero">
    <h1>&#128218; GitHub Actions Architecture (Runner-Based)</h1>
    <p>CI/CD automation — how GitHub Actions uses Runners instead of Master-Slave architecture</p>
  </div>

  <!-- What is GitHub Actions -->
  <section>
    <h2>&#128640; What is GitHub Actions?</h2>
    <p>GitHub Actions is a <strong>CI/CD automation tool</strong> provided by GitHub to build, test, and deploy applications directly from your repository.</p>
  </section>

  <hr>

  <!-- Master-Slave vs GitHub Actions -->
  <section>
    <h2>&#9888;&#65039; Master-Slave vs GitHub Actions</h2>
    <p>In tools like <strong>Jenkins</strong>:</p>
    <div class="warn-box">
      <div class="warn-row"><span class="label">Master</span><span>&#8594; Controls pipelines</span></div>
      <div class="warn-row"><span class="label">Slave (Agent)</span><span>&#8594; Executes jobs</span></div>
    </div>
    <div class="callout"><strong>Note:</strong> GitHub Actions uses a different architecture — there is no Master. Instead, a <strong>Runner</strong> picks up and executes jobs directly.</div>
  </section>

  <hr>

  <!-- GitHub Actions Architecture -->
  <section>
    <h2>&#129504; GitHub Actions Architecture</h2>

    <h3>&#128313; 1. Workflow</h3>
    <ul>
      <li>Defined in <code>.github/workflows/*.yml</code></li>
      <li>Contains jobs and steps</li>
    </ul>

    <h3>&#128313; 2. Runner</h3>
    <p>A <strong>Runner</strong> is a machine that executes jobs.</p>

    <div class="runner-grid">
      <!-- GitHub-Hosted -->
      <div class="runner-card">
        <div class="runner-card-header">
          <div class="runner-icon" style="background:#033a16">&#9989;</div>
          <div>
            <h4>GitHub-Hosted Runner</h4>
            <span>Managed by GitHub</span>
          </div>
        </div>
        <div class="runner-card-body">
          <ul>
            <li>Managed and maintained by GitHub</li>
            <li>No setup required</li>
          </ul>
          <div class="code-block" style="margin-top:.75rem">
            <pre><span class="key">runs-on</span>: <span class="str">ubuntu-latest</span></pre>
          </div>
        </div>
      </div>

      <!-- Self-Hosted -->
      <div class="runner-card self">
        <div class="runner-card-header">
          <div class="runner-icon" style="background:#2d1f6e">&#9989;</div>
          <div>
            <h4>Self-Hosted Runner</h4>
            <span>Your own server</span>
          </div>
        </div>
        <div class="runner-card-body">
          <ul>
            <li>Your own server (EC2, VM, local machine)</li>
            <li>You install runner manually</li>
          </ul>
          <div class="code-block" style="margin-top:.75rem">
            <pre><span class="key">runs-on</span>: <span class="str">self-hosted</span></pre>
          </div>
        </div>
      </div>
    </div>
  </section>

  <hr>

  <!-- Execution Flow -->
  <section>
    <h2>&#128260; Execution Flow</h2>
    <div class="flow-wrap">
      <div class="flow-node trigger">Developer Push / Manual Trigger</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-node workflow">GitHub Actions Workflow</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-node workflow">Job Created</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-node runner">Runner Picks Job</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-node exec">Executes Steps</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-node output">Output Logs</div>
    </div>
  </section>

  <hr>

  <!-- Example Workflow -->
  <section>
    <h2>&#9881;&#65039; Example Workflow</h2>
    <div class="code-block">
      <div class="code-header">
        <span>sample-pipeline.yml</span>
        <button onclick="copyCode(this)" data-target="sample">Copy</button>
      </div>
      <pre id="sample"><span class="key">name</span>: <span class="str">Sample Pipeline</span>

<span class="key">on</span>:
  <span class="val">workflow_dispatch</span>:

<span class="key">jobs</span>:
  <span class="val">build</span>:
    <span class="val">runs-on</span>: <span class="str">ubuntu-latest</span>
    <span class="val">steps</span>:
      - <span class="val">name</span>: <span class="str">Print Message</span>
        <span class="val">run</span>: <span class="str">echo "Hello from GitHub Actions"</span></pre>
    </div>
  </section>

  <hr>

  <!-- Self-Hosted Runner Setup -->
  <section>
    <h2>&#128421;&#65039; Self-Hosted Runner Setup</h2>

    <div class="steps-list">
      <div class="step-item">
        <div class="step-num">1</div>
        <div class="step-content">
          <div class="step-title">Go to Repository</div>
          <div class="step-desc">Settings &#8594; Actions &#8594; Runners</div>
        </div>
      </div>
      <div class="step-item">
        <div class="step-num">2</div>
        <div class="step-content">
          <div class="step-title">Add New Runner</div>
          <div class="step-desc">Choose OS — Linux / Windows / Mac</div>
        </div>
      </div>
      <div class="step-item">
        <div class="step-num">3</div>
        <div class="step-content">
          <div class="step-title">Run Commands on Your Server</div>
          <div class="step-desc">Download, extract, configure and start the runner</div>
        </div>
      </div>
    </div>

    <div class="code-block">
      <div class="code-header">
        <span>terminal (linux)</span>
        <button onclick="copyCode(this)" data-target="runner-setup">Copy</button>
      </div>
      <pre id="runner-setup"><span class="cmt"># Download runner</span>
<span class="cmd">mkdir</span> actions-runner && <span class="cmd">cd</span> actions-runner

<span class="cmt"># Download package</span>
<span class="cmd">curl</span> -o actions-runner.tar.gz -L \
  https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz

<span class="cmt"># Extract</span>
<span class="cmd">tar</span> xzf ./actions-runner.tar.gz

<span class="cmt"># Configure</span>
<span class="cmd">./config.sh</span> --url https://github.com/your-repo --token YOUR_TOKEN

<span class="cmt"># Start runner</span>
<span class="cmd">./run.sh</span></pre>
    </div>
  </section>

  <hr>

  <!-- Using Self-Hosted Runner -->
  <section>
    <h2>&#128278; Using Self-Hosted Runner in Workflow</h2>
    <div class="code-block">
      <div class="code-header"><span>workflow.yml</span></div>
      <pre><span class="key">jobs</span>:
  <span class="val">build</span>:
    <span class="val">runs-on</span>: <span class="str">self-hosted</span></pre>
    </div>
    <p>You can also use labels to target specific runners:</p>
    <div class="code-block">
      <div class="code-header"><span>workflow.yml</span></div>
      <pre><span class="val">runs-on</span>: [<span class="str">self-hosted</span>, <span class="str">linux</span>, <span class="str">dev</span>]</pre>
    </div>
    <div class="callout"><strong>Tip:</strong> Labels like <code>self-hosted</code>, <code>linux</code>, <code>dev</code> help you route jobs to the right runner in a multi-runner setup</div>
  </section>

  <footer>
    <p>GitHub Actions Architecture (Runner-Based) &nbsp;&#8226;&nbsp; CI/CD Reference Guide</p>
  </footer>

</div>

<script>
function copyCode(btn) {
  const id = btn.getAttribute('data-target');
  const el = document.getElementById(id);
  const text = el.innerText;
  navigator.clipboard.writeText(text).then(() => {
    btn.textContent = 'Copied!';
    setTimeout(() => btn.textContent = 'Copy', 2000);
  });
}
</script>
</body>
</html>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GitHub Actions Architecture</title>
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

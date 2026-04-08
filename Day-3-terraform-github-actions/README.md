<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GitHub Actions + Terraform CI/CD Pipeline</title>
</head>
<body>
<div class="container">

  <!-- Hero -->
  <div class="hero">
    <h1>&#128218; GitHub Actions + Terraform CI/CD Pipeline</h1>
    <p>Automate infrastructure deployments with GitHub Actions and Terraform on AWS</p>
    <div class="badges">
      <span class="badge badge-blue">GitHub Actions</span>
      <span class="badge badge-green">Terraform</span>
      <span class="badge badge-orange">AWS</span>
      <span class="badge badge-purple">CI/CD</span>
    </div>
  </div>

  <!-- What is GitHub Actions -->
  <section>
    <h2>&#128640; What is GitHub Actions?</h2>
    <p>GitHub Actions is a <strong>CI/CD tool</strong> that lets you automate build, test, and deployment workflows directly from your GitHub repository — no external CI server required.</p>
  </section>

  <!-- What is a Pipeline -->
  <section>
    <h2>&#128260; What is a Pipeline?</h2>
    <p>A pipeline is a sequence of automated steps executed in order:</p>
    <div class="steps-grid" style="grid-template-columns:repeat(auto-fit,minmax(180px,1fr))">
      <div class="step"><div class="step-num">1</div><div class="step-content"><div class="step-label">Fetch code</div></div></div>
      <div class="step"><div class="step-num">2</div><div class="step-content"><div class="step-label">Build / Validate</div></div></div>
      <div class="step"><div class="step-num">3</div><div class="step-content"><div class="step-label">Test</div></div></div>
      <div class="step"><div class="step-num">4</div><div class="step-content"><div class="step-label">Deploy</div></div></div>
    </div>
    <div class="callout"><strong>Note:</strong> In GitHub Actions, pipelines are called <strong>Workflows</strong></div>
  </section>

  <!-- Setup -->
  <section>
    <h2>&#128193; How to Create a Workflow File</h2>
    <p>Create the following directory and file inside your repository:</p>
    <div class="code-block">
      <div class="code-header"><span>directory structure</span></div>
      <pre><span class="cmt"># Create this folder structure in your repo</span>
your-repo/
&#9500;&#9472;&#9472; .github/
&#9474;   &#9492;&#9472;&#9472; workflows/
&#9474;       &#9492;&#9472;&#9472; <span class="str">terraform.yml</span>   <span class="cmt">&#8592; your workflow file</span>
&#9500;&#9472;&#9472; main.tf
&#9492;&#9472;&#9472; variables.tf</pre>
    </div>
  </section>

  <!-- Triggers -->
  <section>
    <h2>&#9889; Workflow Triggers</h2>
    <div class="trigger-grid">
      <div class="trigger-card">
        <h4>&#128313; Manual Trigger <span class="trigger-type badge badge-purple">manual</span></h4>
        <div class="code-block" style="margin:.5rem 0"><pre><span class="key">on</span>:
  <span class="val">workflow_dispatch</span>:</pre></div>
        <p>Run manually from GitHub UI — useful for controlled deployments</p>
      </div>
      <div class="trigger-card">
        <h4>&#128313; Push Trigger <span class="trigger-type badge badge-green">auto</span></h4>
        <div class="code-block" style="margin:.5rem 0"><pre><span class="key">on</span>:
  <span class="val">push</span>:
    <span class="val">branches</span>:
      - <span class="str">main</span></pre></div>
        <p>Auto-runs when code is pushed to the main branch</p>
      </div>
      <div class="trigger-card">
        <h4>&#128313; Both <span class="trigger-type badge badge-blue">combined</span></h4>
        <div class="code-block" style="margin:.5rem 0"><pre><span class="key">on</span>:
  <span class="val">push</span>:
    <span class="val">branches</span>: [<span class="str">main</span>]
  <span class="val">workflow_dispatch</span>:</pre></div>
        <p>Supports both automatic and manual execution</p>
      </div>
    </div>
  </section>

  <!-- Basic Pipeline -->
  <section>
    <h2>&#127757; Terraform Pipeline (Basic)</h2>
    <div class="code-block">
      <div class="code-header">
        <span>terraform.yml</span>
        <button onclick="copyCode(this)" data-target="basic">Copy</button>
      </div>
      <pre id="basic"><span class="key">name</span>: <span class="str">Terraform Deploy</span>

<span class="key">on</span>:
  <span class="val">push</span>:
    <span class="val">branches</span>: [<span class="str">main</span>]
  <span class="val">workflow_dispatch</span>:

<span class="key">jobs</span>:
  <span class="val">terraform</span>:
    <span class="val">runs-on</span>: <span class="str">ubuntu-latest</span>
    <span class="val">env</span>:
      <span class="val">AWS_ACCESS_KEY_ID</span>: <span class="str">${{ secrets.AWS_ACCESS_KEY_ID }}</span>
      <span class="val">AWS_SECRET_ACCESS_KEY</span>: <span class="str">${{ secrets.AWS_SECRET_ACCESS_KEY }}</span>
      <span class="val">AWS_DEFAULT_REGION</span>: <span class="str">us-east-1</span>
    <span class="val">steps</span>:
      - <span class="val">name</span>: <span class="str">Checkout Code</span>
        <span class="val">uses</span>: <span class="str">actions/checkout@v4</span>

      - <span class="val">name</span>: <span class="str">Setup Terraform</span>
        <span class="val">uses</span>: <span class="str">hashicorp/setup-terraform@v3</span>

      - <span class="val">name</span>: <span class="str">Terraform Init</span>
        <span class="val">run</span>: <span class="str">terraform init</span>

      - <span class="val">name</span>: <span class="str">Terraform Validate</span>
        <span class="val">run</span>: <span class="str">terraform validate</span>

      - <span class="val">name</span>: <span class="str">Terraform Plan</span>
        <span class="val">run</span>: <span class="str">terraform plan -out=tfplan</span>

      - <span class="val">name</span>: <span class="str">Terraform Apply</span>
        <span class="val">run</span>: <span class="str">terraform apply -auto-approve tfplan</span></pre>
    </div>
  </section>

  <!-- Steps Explanation -->
  <section>
    <h2>&#129150; Steps Explanation</h2>
    <div class="steps-grid">
      <div class="step"><div class="step-num">1</div><div class="step-content"><div class="step-label">actions/checkout@v4</div><div class="step-desc">Downloads repository code from GitHub onto the runner</div></div></div>
      <div class="step"><div class="step-num">2</div><div class="step-content"><div class="step-label">hashicorp/setup-terraform@v3</div><div class="step-desc">Installs the Terraform CLI on the ubuntu-latest runner</div></div></div>
      <div class="step"><div class="step-num">3</div><div class="step-content"><div class="step-label">terraform init</div><div class="step-desc">Initializes the working directory, downloads providers</div></div></div>
      <div class="step"><div class="step-num">4</div><div class="step-content"><div class="step-label">terraform validate</div><div class="step-desc">Checks <code>.tf</code> files for syntax and config errors</div></div></div>
      <div class="step"><div class="step-num">5</div><div class="step-content"><div class="step-label">terraform plan -out=tfplan</div><div class="step-desc">Shows what infrastructure changes will be made, saves plan</div></div></div>
      <div class="step"><div class="step-num">6</div><div class="step-content"><div class="step-label">terraform apply -auto-approve tfplan</div><div class="step-desc">Deploys the planned changes to AWS automatically</div></div></div>
    </div>
  </section>

  <!-- Manual Approval -->
  <section>
    <h2>&#128274; Manual Approval (Production Safe)</h2>
    <p>GitHub Actions uses <strong>Environments</strong> for approval gates. The pipeline pauses until a required reviewer approves — no <code>input</code> step needed like in Jenkins.</p>

    <h3>Step 1 — Add environment to workflow</h3>
    <div class="code-block">
      <div class="code-header"><span>terraform.yml</span></div>
      <pre><span class="key">jobs</span>:
  <span class="val">terraform</span>:
    <span class="val">runs-on</span>: <span class="str">ubuntu-latest</span>
    <span class="val">environment</span>: <span class="str">production</span>  <span class="cmt"># &#8592; adds approval gate</span></pre>
    </div>

    <h3>Step 2 — Configure in GitHub</h3>
    <div class="env-steps">
      <div class="env-step"><div class="env-num">1</div><span>Go to <strong>Settings &#8594; Environments</strong> in your repository</span></div>
      <div class="env-step"><div class="env-num">2</div><span>Create a new environment named <code>production</code></span></div>
      <div class="env-step"><div class="env-num">3</div><span>Add <strong>Required reviewers</strong> — team members who can approve deployments</span></div>
    </div>
    <div class="callout"><strong>Result:</strong> The pipeline will pause before <code>terraform apply</code> until an approved reviewer clicks <strong>Approve and deploy</strong> in the GitHub UI</div>
  </section>

  <!-- Advanced Pipeline -->
  <section>
    <h2>&#128257; Advanced Pipeline with Approval</h2>
    <div class="code-block">
      <div class="code-header">
        <span>terraform.yml</span>
        <button onclick="copyCode(this)" data-target="advanced">Copy</button>
      </div>
      <pre id="advanced"><span class="key">name</span>: <span class="str">Terraform Deploy with Approval</span>

<span class="key">on</span>:
  <span class="val">workflow_dispatch</span>:

<span class="key">jobs</span>:
  <span class="val">terraform</span>:
    <span class="val">runs-on</span>: <span class="str">ubuntu-latest</span>
    <span class="val">environment</span>: <span class="str">production</span>  <span class="cmt"># &#8592; required reviewer gate</span>
    <span class="val">steps</span>:
      - <span class="val">name</span>: <span class="str">Checkout</span>
        <span class="val">uses</span>: <span class="str">actions/checkout@v4</span>

      - <span class="val">name</span>: <span class="str">Setup Terraform</span>
        <span class="val">uses</span>: <span class="str">hashicorp/setup-terraform@v3</span>

      - <span class="val">name</span>: <span class="str">Init</span>
        <span class="val">run</span>: <span class="str">terraform init</span>

      - <span class="val">name</span>: <span class="str">Plan</span>
        <span class="val">run</span>: <span class="str">terraform plan</span>

      - <span class="val">name</span>: <span class="str">Apply</span>
        <span class="val">run</span>: <span class="str">terraform apply -auto-approve</span></pre>
    </div>
  </section>

  <!-- Best Practices -->
  <section>
    <h2>&#128274; Best Practices</h2>
    <div class="bp-grid">
      <div class="bp-card"><div class="bp-icon">&#128273;</div><div class="bp-text"><div class="bp-title">Use GitHub Secrets for credentials</div><div class="bp-desc">Never hardcode AWS keys or tokens in YAML files</div></div></div>
      <div class="bp-card"><div class="bp-icon">&#128683;</div><div class="bp-text"><div class="bp-title">Avoid <code>-auto-approve</code> in production</div><div class="bp-desc">Use manual approval environments instead of auto-applying</div></div></div>
      <div class="bp-card"><div class="bp-icon">&#9729;&#65039;</div><div class="bp-text"><div class="bp-title">Use remote backend (S3 + DynamoDB)</div><div class="bp-desc">Store state in S3, use DynamoDB for state locking</div></div></div>
      <div class="bp-card"><div class="bp-icon">&#127760;</div><div class="bp-text"><div class="bp-title">Separate environments</div><div class="bp-desc">Use distinct workflows or jobs for dev / stage / prod</div></div></div>
      <div class="bp-card"><div class="bp-icon">&#9989;</div><div class="bp-text"><div class="bp-title">Enable approval for production</div><div class="bp-desc">Configure Required reviewers in GitHub Environments settings</div></div></div>
    </div>
  </section>

  <!-- Flow -->
  <section>
    <h2>&#128257; Workflow Execution Flow</h2>
    <div class="flow">
      <div class="flow-step trigger">Push / Manual Trigger</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step">Checkout Code</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step">Setup Terraform</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step">terraform init</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step">terraform validate</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step">terraform plan</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step approval">&#9201; Approval Gate (if enabled)</div>
      <div class="flow-arrow">&#8595;</div>
      <div class="flow-step apply">terraform apply</div>
    </div>
  </section>

  <footer>
    <p>GitHub Actions + Terraform CI/CD Pipeline &nbsp;&#8226;&nbsp; Infrastructure as Code Reference</p>
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

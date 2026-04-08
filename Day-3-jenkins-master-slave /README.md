<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Jenkins Master-Slave Architecture</title>
<style>
  *{margin:0;padding:0;box-sizing:border-box}
  body{font-family:'Segoe UI',system-ui,sans-serif;background:#0d1117;color:#e6edf3;line-height:1.7;font-size:15px}
  .container{max-width:960px;margin:0 auto;padding:2rem 1.5rem}

  /* Hero */
  .hero{border-bottom:1px solid #21262d;padding:2.5rem 0 2rem;margin-bottom:2rem}
  .hero h1{font-size:2rem;font-weight:600;color:#f0f6fc;display:flex;align-items:center;gap:.6rem;flex-wrap:wrap}
  .hero p{color:#8b949e;margin-top:.5rem;font-size:.95rem}
  .badges{display:flex;flex-wrap:wrap;gap:.5rem;margin-top:1rem}
  .badge{font-size:.72rem;font-weight:600;padding:3px 10px;border-radius:20px;letter-spacing:.03em}
  .badge-blue{background:#0d419d;color:#79c0ff;border:1px solid #1f6feb}
  .badge-green{background:#033a16;color:#56d364;border:1px solid #238636}
  .badge-orange{background:#4d2d00;color:#ffa657;border:1px solid #9e6a03}
  .badge-red{background:#4d0000;color:#ff7b72;border:1px solid #da3633}

  /* Section */
  section{margin-bottom:2.5rem}
  h2{font-size:1.2rem;font-weight:600;color:#f0f6fc;padding-bottom:.5rem;border-bottom:1px solid #21262d;margin-bottom:1rem;display:flex;align-items:center;gap:.5rem}
  h3{font-size:.95rem;font-weight:600;color:#c9d1d9;margin:1.2rem 0 .5rem;display:flex;align-items:center;gap:.4rem}
  p{color:#c9d1d9;margin-bottom:.75rem;font-size:.93rem}
  strong{color:#f0f6fc}

  /* Callout */
  .callout{background:#161b22;border-left:3px solid #1f6feb;border-radius:0 6px 6px 0;padding:.7rem 1rem;margin:.75rem 0;font-size:.88rem;color:#8b949e}
  .callout strong{color:#58a6ff}

  /* Cards grid */
  .arch-grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin:.75rem 0}
  @media(max-width:600px){.arch-grid{grid-template-columns:1fr}}
  .arch-card{background:#161b22;border:1px solid #30363d;border-radius:10px;overflow:hidden}
  .arch-card-header{padding:.8rem 1rem;display:flex;align-items:center;gap:.6rem;border-bottom:1px solid #30363d}
  .arch-card-header .icon{width:34px;height:34px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:1rem;flex-shrink:0}
  .icon-master{background:#0d419d}
  .icon-agent{background:#033a16}
  .arch-card-header h4{font-size:.95rem;font-weight:600;color:#f0f6fc;margin:0}
  .arch-card-header span{font-size:.73rem;color:#8b949e;margin-top:1px}
  .arch-card-body{padding:.9rem 1rem}
  .resp-list{list-style:none;display:flex;flex-direction:column;gap:.45rem}
  .resp-list li{display:flex;align-items:flex-start;gap:.55rem;font-size:.87rem;color:#c9d1d9}
  .resp-list li::before{content:'';width:6px;height:6px;border-radius:50%;background:#30363d;flex-shrink:0;margin-top:.52rem}
  .resp-list.blue li::before{background:#1f6feb}
  .resp-list.green li::before{background:#238636}

  /* Agent types */
  .agent-types{display:flex;flex-wrap:wrap;gap:.5rem;margin-top:.8rem}
  .agent-tag{display:flex;align-items:center;gap:.4rem;background:#161b22;border:1px solid #30363d;border-radius:6px;padding:.35rem .75rem;font-size:.82rem;color:#c9d1d9}
  .agent-tag .dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
  .dot-linux{background:#56d364}
  .dot-windows{background:#79c0ff}
  .dot-cloud{background:#ffa657}

  /* Flow */
  .flow-wrap{display:flex;flex-direction:column;align-items:center;gap:0;margin:1rem auto;max-width:380px}
  .flow-node{width:100%;display:flex;align-items:center;justify-content:center;border-radius:8px;padding:.6rem 1.2rem;font-size:.88rem;font-weight:600;text-align:center;border:1px solid #30363d;background:#161b22;color:#f0f6fc}
  .flow-node.trigger{border-color:#1f6feb;color:#58a6ff;background:#0a1628}
  .flow-node.master{border-color:#9e6a03;color:#e3b341;background:#1a1200}
  .flow-node.assign{border-color:#8957e5;color:#d2a8ff;background:#150d2e}
  .flow-node.agent{border-color:#238636;color:#56d364;background:#0a1f0e}
  .flow-node.result{border-color:#238636;color:#56d364;background:#0a1f0e}
  .flow-node.dashboard{border-color:#1f6feb;color:#58a6ff;background:#0a1628}
  .flow-arrow{color:#484f58;font-size:1.1rem;line-height:1;margin:4px 0}
  .flow-label{font-size:.72rem;color:#484f58;margin-top:-2px;margin-bottom:2px}

  /* How it works visual */
  .how-box{background:#161b22;border:1px solid #30363d;border-radius:10px;padding:1.2rem;margin:.75rem 0}

  /* Code block */
  .code-block{background:#161b22;border:1px solid #30363d;border-radius:8px;overflow:hidden;margin:.75rem 0}
  .code-header{background:#1c2128;border-bottom:1px solid #30363d;padding:.4rem 1rem;display:flex;align-items:center;justify-content:space-between}
  .code-header span{font-size:.75rem;color:#8b949e;font-family:'Courier New',monospace}
  pre{padding:1rem;overflow-x:auto;font-family:'Courier New',monospace;font-size:.82rem;line-height:1.8;color:#e6edf3}

  /* Summary table */
  .table-wrap{overflow-x:auto;margin:.75rem 0}
  table{width:100%;border-collapse:collapse;font-size:.87rem}
  th{background:#161b22;color:#8b949e;font-weight:600;text-align:left;padding:.6rem .9rem;border-bottom:1px solid #30363d;font-size:.78rem;text-transform:uppercase;letter-spacing:.05em}
  td{padding:.6rem .9rem;border-bottom:1px solid #21262d;color:#c9d1d9;vertical-align:top}
  tr:last-child td{border-bottom:none}
  tr:hover td{background:#161b22}
  code{font-family:'Courier New',monospace;background:#21262d;color:#79c0ff;padding:2px 6px;border-radius:4px;font-size:.8rem;border:1px solid #30363d}

  /* Divider */
  .divider{border:none;border-top:1px solid #21262d;margin:2rem 0}

  /* Footer */
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
    <h1>&#128218; Jenkins Master-Slave Architecture</h1>
    <p>Controller-Agent distributed build architecture — how Jenkins scales CI/CD across multiple machines</p>
    <div class="badges">
      <span class="badge badge-red">Jenkins</span>
      <span class="badge badge-blue">CI/CD</span>
      <span class="badge badge-green">Controller-Agent</span>
      <span class="badge badge-orange">Distributed Builds</span>
    </div>
  </div>

  <!-- What is Jenkins -->
  <section>
    <h2>&#128640; What is Jenkins?</h2>
    <p>Jenkins is an <strong>open-source automation server</strong> used to implement CI/CD pipelines. It automates the repetitive parts of software development:</p>
    <div style="display:flex;flex-wrap:wrap;gap:.6rem;margin:.75rem 0">
      <div style="display:flex;align-items:center;gap:.5rem;background:#161b22;border:1px solid #30363d;border-radius:6px;padding:.45rem .85rem;font-size:.87rem;color:#c9d1d9">&#127959;&#65039; Build applications</div>
      <div style="display:flex;align-items:center;gap:.5rem;background:#161b22;border:1px solid #30363d;border-radius:6px;padding:.45rem .85rem;font-size:.87rem;color:#c9d1d9">&#129514; Run tests</div>
      <div style="display:flex;align-items:center;gap:.5rem;background:#161b22;border:1px solid #30363d;border-radius:6px;padding:.45rem .85rem;font-size:.87rem;color:#c9d1d9">&#128640; Deploy code automatically</div>
    </div>
  </section>

  <hr class="divider">

  <!-- Architecture Overview -->
  <section>
    <h2>&#129504; Jenkins Architecture</h2>
    <p>Jenkins follows a <strong>Master-Slave architecture</strong> — now officially called <strong>Controller-Agent</strong>. This allows Jenkins to distribute workloads across many machines for parallel, scalable builds.</p>

    <div class="arch-grid">
      <!-- Master Card -->
      <div class="arch-card">
        <div class="arch-card-header">
          <div class="icon icon-master">&#128081;</div>
          <div>
            <h4>Master (Controller)</h4>
            <span>Main Jenkins server</span>
          </div>
        </div>
        <div class="arch-card-body">
          <ul class="resp-list blue">
            <li>Manage pipelines and jobs</li>
            <li>Schedule builds</li>
            <li>Monitor execution</li>
            <li>Assign jobs to agents</li>
            <li>Provide UI dashboard</li>
          </ul>
        </div>
      </div>

      <!-- Agent Card -->
      <div class="arch-card">
        <div class="arch-card-header">
          <div class="icon icon-agent">&#9881;&#65039;</div>
          <div>
            <h4>Slave (Agent)</h4>
            <span>Worker machine</span>
          </div>
        </div>
        <div class="arch-card-body">
          <ul class="resp-list green">
            <li>Execute build jobs</li>
            <li>Run scripts and commands</li>
            <li>Handle workload from master</li>
          </ul>
          <div style="margin-top:.85rem">
            <div style="font-size:.78rem;color:#8b949e;margin-bottom:.45rem;font-weight:600;text-transform:uppercase;letter-spacing:.05em">Agent types</div>
            <div class="agent-types">
              <div class="agent-tag"><span class="dot dot-linux"></span>Linux machines</div>
              <div class="agent-tag"><span class="dot dot-windows"></span>Windows machines</div>
              <div class="agent-tag"><span class="dot dot-cloud"></span>Cloud (AWS EC2)</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <hr class="divider">

  <!-- How it Works -->
  <section>
    <h2>&#128260; How It Works</h2>
    <p>When a developer pushes code, Jenkins Master picks it up, assigns the job to an available agent, and the agent executes and reports back.</p>

    <div class="how-box">
      <div class="flow-wrap">
        <div class="flow-node trigger">&#128100; Developer pushes code</div>
        <div class="flow-arrow">&#8595;</div>
        <div class="flow-node master">&#128081; Jenkins Master receives event</div>
        <div class="flow-arrow">&#8595;</div>
        <div class="flow-node assign">&#128228; Assign job to available Agent</div>
        <div class="flow-arrow">&#8595;</div>
        <div class="flow-node agent">&#9881;&#65039; Agent executes the job</div>
        <div class="flow-arrow">&#8595;</div>
        <div class="flow-node result">&#128228; Send result back to Master</div>
        <div class="flow-arrow">&#8595;</div>
        <div class="flow-node dashboard">&#128250; Display in Dashboard</div>
      </div>
    </div>
  </section>

  <hr class="divider">

  <!-- Summary Table -->
  <section>
    <h2>&#128203; Quick Reference</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Component</th>
            <th>Also Called</th>
            <th>Role</th>
            <th>Runs On</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong style="color:#e3b341">Master</strong></td>
            <td>Controller</td>
            <td>Manages, schedules, monitors jobs — hosts the UI</td>
            <td>Dedicated Jenkins server</td>
          </tr>
          <tr>
            <td><strong style="color:#56d364">Slave</strong></td>
            <td>Agent</td>
            <td>Executes jobs assigned by the master</td>
            <td>Linux / Windows / Cloud VM</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>

  <hr class="divider">

  <!-- Jenkinsfile -->
  <section>
    <h2>&#128196; Example Jenkinsfile</h2>
    <p>A basic declarative pipeline that runs on a specific agent:</p>
    <div class="code-block">
      <div class="code-header"><span>Jenkinsfile</span></div>
      <pre>pipeline {
    agent { label <span style="color:#a5d6ff">'linux-agent'</span> }  <span style="color:#8b949e">// run on a specific agent</span>

    stages {
        stage(<span style="color:#a5d6ff">'Checkout'</span>) {
            steps {
                checkout scm
            }
        }
        stage(<span style="color:#a5d6ff">'Build'</span>) {
            steps {
                sh <span style="color:#a5d6ff">'mvn clean install'</span>
            }
        }
        stage(<span style="color:#a5d6ff">'Test'</span>) {
            steps {
                sh <span style="color:#a5d6ff">'mvn test'</span>
            }
        }
        stage(<span style="color:#a5d6ff">'Deploy'</span>) {
            steps {
                sh <span style="color:#a5d6ff">'./deploy.sh'</span>
            }
        }
    }

    post {
        success { echo <span style="color:#a5d6ff">'Build succeeded!'</span> }
        failure { echo <span style="color:#a5d6ff">'Build failed.'</span> }
    }
}</pre>
    </div>
    <div class="callout"><strong>Note:</strong> <code>agent { label 'linux-agent' }</code> tells the Master to assign this job to any agent with the label <code>linux-agent</code></div>
  </section>

  <footer>
    <p>Jenkins Master-Slave (Controller-Agent) Architecture &nbsp;&#8226;&nbsp; CI/CD Reference Guide</p>
  </footer>

</div>
</body>
</html>

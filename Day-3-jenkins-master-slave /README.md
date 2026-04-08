<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Jenkins Master-Slave Architecture</title>
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

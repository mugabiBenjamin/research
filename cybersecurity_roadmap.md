# Complete Cybersecurity Learning Roadmap

## Phase 1: Foundation (3-4 months)

### Prerequisites & Core Knowledge

### Linux Fundamentals (4-6 weeks)

- Basic commands, file system, permissions
- Shell scripting basics
- System administration
- Network configuration
- **Ubuntu is perfect for this phase** - use it throughout

### Networking Basics (3-4 weeks)

- OSI/TCP-IP models
- Subnetting, VLANs
- Common protocols (HTTP/S, DNS, DHCP)
- Wireshark for packet analysis

### Programming Fundamentals (4-5 weeks)

- Python (essential for security tools)
- Bash scripting
- Basic understanding of C/C++
- SQL basics

**Resources:**

- Linux: "The Linux Command Line" book
- Networking: CompTIA Network+ materials
- Python: Automate the Boring Stuff

---

## Phase 2: Security Fundamentals (2-3 months)

### Core Security Concepts (3-4 weeks)

- CIA Triad, risk assessment
- Cryptography basics
- Authentication vs authorization
- Common vulnerabilities (OWASP Top 10)

### System Security (3-4 weeks)

- Windows/Linux hardening
- Access controls
- Logging and monitoring
- Antivirus/EDR concepts

### Network Security (2-3 weeks)

- Firewalls, IDS/IPS
- VPNs, network segmentation
- Wireless security

**Certification Target:** Security+ (optional but recommended)

---

## Phase 3: Hands-On Security Skills (3-4 months)

### Vulnerability Assessment (4-5 weeks)

- Nmap, Nessus
- OpenVAS (free alternative)
- Vulnerability scanning methodology
- **Ubuntu handles these tools perfectly**

### Basic Penetration Testing (4-6 weeks)

- Metasploit basics
- Web application testing (Burp Suite Community)
- Basic exploitation techniques
- Report writing

### Incident Response Basics (2-3 weeks)

- Digital forensics concepts
- Log analysis
- Malware analysis basics

**Practice:**

- VulnHub VMs
- TryHackMe (beginner rooms)
- OverTheWire wargames

---

## Phase 4: Specialization Choice (4-6 months)

**Choose 1-2 areas based on career goals:**

### Option A: Penetration Testing

- Advanced web app testing
- Network penetration testing
- Social engineering
- **Target:** CEH or OSCP certification

### Option B: SOC Analyst/Blue Team

- SIEM tools (Splunk, ELK stack)
- Threat hunting
- Malware analysis
- **Target:** CySA+ or GCIH certification

### Option C: GRC (Governance, Risk, Compliance)

- Risk management frameworks
- Compliance standards (ISO 27001, NIST)
- Policy development
- **Target:** CISA or CRISC certification

### Option D: Cloud Security

- AWS/Azure security
- Container security
- DevSecOps basics
- **Target:** Cloud security certifications

---

## Phase 5: Advanced Skills & Career Prep (3-6 months)

### Professional Development

- Industry networking
- Portfolio building
- Technical blog writing
- Conference participation (virtual)

### Advanced Certifications

- CISSP (for management track)
- Advanced technical certs in chosen specialization
- Vendor-specific certifications

### Real-World Experience

- Bug bounty programs
- Open source contributions
- Internships/entry-level positions
- Home lab expansion

---

## Ubuntu Setup for Cybersecurity

**Ubuntu is absolutely sufficient for cybersecurity learning.** Here's what you can run:

### Essential Tools Available on Ubuntu

- **Network Analysis:** Wireshark, tcpdump, Nmap
- **Web Testing:** Burp Suite, OWASP ZAP, sqlmap
- **Vulnerability Scanning:** OpenVAS, Nikto
- **Forensics:** Autopsy, Volatility
- **Programming:** Python, VS Code, Git
- **Virtualization:** VirtualBox (for practicing on vulnerable VMs)

### Ubuntu Advantages

- Lighter resource usage than Kali
- More stable for daily use
- Better for learning fundamentals
- Easy to install security tools via apt
- Professional environment simulation

### Making Ubuntu Security-Focused

```bash
# Install essential security tools
sudo apt update
sudo apt install nmap wireshark burpsuite nikto sqlmap metasploit-framework

# Add Kali repositories for additional tools (optional)
echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" | sudo tee /etc/apt/sources.list.d/kali.list
```

---

## Total Timeline: 15-20 months to job-ready

### Realistic Expectations

- **Part-time (10-15 hrs/week):** 18-24 months
- **Full-time (40+ hrs/week):** 12-15 months
- **Intensive (60+ hrs/week):** 10-12 months

### Budget-Friendly Resources

- **Free:** TryHackMe, Cybrary, YouTube channels
- **Low-cost:** Udemy courses ($10-20), VulnHub VMs
- **Investment priority:** 1-2 key certifications ($300-500 each)

### Success Metrics by Phase

1. **Phase 1:** Comfortable with Linux CLI, basic Python scripts
2. **Phase 2:** Understanding security concepts, first certification
3. **Phase 3:** Can perform basic pentests, vulnerability assessments
4. **Phase 4:** Specialized skills, advanced certification
5. **Phase 5:** Portfolio ready, applying for jobs

**Key Success Factor:** Consistency over intensity. 1-2 hours daily beats weekend marathons.

# Module 7: Navigating the Filesystem

**Course:** NetAcad Linux | **Lab environment:** Ubuntu 18.04.5 LTS (NetAcad lab VM) | **User:** `sysadmin`

This write-up documents the hands-on lab completed over the week, the commands used, what each one does, and what I learned from the mistakes along the way.

---

## 1. Concepts in my own words

- **The filesystem is a single tree.** Everything starts at the root directory `/`. Home directories live under `/home`, system configuration under `/etc`, logs under `/var/log`, and programs under `/usr/bin`.
- **Absolute path vs relative path.** An absolute path starts with `/` and works from anywhere (`/home/sysadmin/Documents/School/Art`). A relative path starts from where I currently am (`School/Art`), so it only works from the right place.
- **Shortcuts.** `.` is the current directory, `..` is the parent directory, and `~` is the current user's home directory.
- **Linux is case-sensitive.** `Documents` and `DOcuments` are different names.
- **Globbing.** The shell expands wildcards (`*`, `?`, `[ ]`) into matching file names *before* the command runs.

---

## 2. Commands used

| Command | Purpose |
|---|---|
| `pwd` | Print the current working directory |
| `cd <path>` | Change directory (absolute or relative) |
| `cd ..` | Move up one level |
| `cd` / `cd ~` | Go to my home directory |
| `ls` | List directory contents |
| `ls -a` | Include hidden files |
| `ls -l` | Long listing: permissions, owner, group, size, date, name |
| `ls -lrt` | Long listing, sorted by modification time, oldest first |
| `ls -R` | Recursive listing |
| `ls -d` | List the directory entry itself, not its contents |
| `\ls` | Run `ls` while bypassing the alias |
| `echo ~user` | Show the home directory of a given user |

---

## 3. Lab walkthrough

### 3.1 Starting the lab and the `$HOME` variable

![Lab start](../screenshots/06-lab-start-and-home-variable.png)

- **Action:** Logged in as `sysadmin` and confirmed my location.
- **Method:** `pwd` returned `/home/sysadmin`, then I ran `echo $Home`.
- **Outcome:** The shell printed an empty line, because the variable is `$HOME` (upper case). Variable names are case-sensitive, just like file names.

### 3.2 Tilde expansion and absolute paths

![Tilde expansion](../screenshots/07-tilde-expansion-and-absolute-paths.png)

- **Action:** Expanded the `~` shortcut for several users.
- **Method:** `echo ~ ~sysadmin ~root ~mail ~nobody`
- **Outcome:** `~` and `~sysadmin` both gave `/home/sysadmin`, `~root` gave `/root`, `~mail` gave `/var/mail`, and `~nobody` gave `/nonexistent`.
- **Action:** Tried to enter root's home directory with `cd ~root`.
- **Outcome:** `Permission denied`. A normal user cannot enter `/root`.
- **Action:** Moved between `/usr/bin`, `/usr`, `/usr/share/doc`, and `/usr/share/doc/bash` using absolute and relative paths, checking with `pwd` each time.
- **Outcome:** Confirmed that absolute paths work from anywhere, while `cd bash` only worked because I was already in `/usr/share/doc`.
- **Mistake:** I typed `pwd\` followed by `q`. The trailing backslash joined the lines and the shell ran `pwdq`, giving `Command 'pwdq' not found, did you mean...`. Lesson: a trailing `\` means "line continues".

### 3.3 `cd` with the wrong arguments

![cd arguments](../screenshots/01-cd-errors-and-arguments.png)

- **Action:** Tested `pwd [OPTIONS]` and `cd [OPTIONS] [path]` exactly as written in the syntax notes.
- **Outcome:** `cd` returned `too many arguments`. The square brackets in the syntax notation mean *optional*; they are not meant to be typed.
- **Action:** Used `cd Junk` and `cd Documents` from the wrong places.
- **Outcome:** `No such file or directory`. A relative path only works if the target is inside the current directory.

### 3.4 Relative vs absolute paths

![Relative vs absolute](../screenshots/02-cd-relative-vs-absolute.png)

- **Action:** From `~/Documents/School/Art`, I tried `cd Art` and `cd School/Art`.
- **Outcome:** Both failed, because I was already inside `Art`. `pwd` confirmed `/home/sysadmin/Documents/School/Art`. Then `cd ..` moved me up to `~/Documents/School`.

### 3.5 Case sensitivity

![Case sensitivity](../screenshots/05-cd-case-sensitivity.png)

- **Action:** Tried `cd DOcuments`, `cd School`, `cd Art`, and `cd School/Art` from inside `Art`.
- **Outcome:** All failed. `DOcuments` is not `Documents` (case matters), and the others pointed at directories that were not inside my current location.

### 3.6 Listing files with `ls -lrt`

![ls -lrt](../screenshots/03-ls-lrt-etc-ssh.png)

- **Action:** Listed the SSH configuration directory.
- **Method:** `ls -lrt /etc/ssh`
- **Outcome:** The same files appear in a different order from the plain `ls -l`. With `-r -t` the oldest files (`sshd_config`, `ssh_config`, `moduli`, March 2019) come first and the newest (host keys, February 2021) come last.
- **Security note:** Private keys such as `ssh_host_rsa_key` are `-rw-------` (only root can read them), while public keys (`.pub`) are `-rw-r--r--`.

### 3.7 Aliases and `/var/log`

![ls alias and var log](../screenshots/04-ls-alias-and-var-log.png)

- **Action:** Compared `ls` with `\ls`, then ran `ls -a`, `ls -l`, and `ls -l /var/log/`.
- **Outcome:** The message `ls is aliased to 'ls --color=auto'` explains the coloured output; the backslash runs the plain command instead. `ls -a` revealed only `.` and `..` in the empty `Downloads` folder, so `ls -l` reported `total 0`. In `/var/log`, files such as `auth.log` and `syslog` are owned by `syslog:adm`, showing that logs are restricted to privileged groups.

### 3.8 File globbing

![Globbing](../screenshots/08-ls-globbing-patterns.png)

- **Action:** Used wildcards to match groups of files.
- **Method and outcome:**

| Command | What it matched |
|---|---|
| `ls -l /etc/hosts` | A single file (172 bytes, owned by root) |
| `ls -R /etc/udev` | `udev` and its sub-directories `hwdb.d` and `rules.d` |
| `ls -d /etc/s*` | Everything in `/etc` starting with `s` |
| `ls -d /etc/????` | Names in `/etc` that are exactly four characters long |
| `ls -d /etc/ [abcd] *` | **Error:** the spaces split this into three separate arguments |

- **Lesson:** The last command was meant to be `ls -d /etc/[abcd]*`. A stray space turned one pattern into three arguments, so `ls` looked for a file literally called `[abcd]` and listed `/etc/` and my home directory contents instead.

---

## 4. Key takeaways

- **Action:** Check my location before using a relative path.
- **Method:** Run `pwd`, then `ls`, then `cd`.
- **Outcome:** Fewer `No such file or directory` errors.

- **Action:** Read error messages carefully.
- **Method:** Match each message (`too many arguments`, `Permission denied`, `not found`) to its cause.
- **Outcome:** Faster troubleshooting, a habit that carries over to cloud and DevOps work.

- **Action:** Treat every character as meaningful.
- **Method:** Watch capitals, spaces, and trailing backslashes.
- **Outcome:** Avoided the `$Home`, `DOcuments`, and `pwd\` style mistakes.

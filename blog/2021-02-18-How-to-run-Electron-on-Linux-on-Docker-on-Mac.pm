{
  version: 2,
  children: [
    {
      type: 'liveCode',
      children: [
        {
          text: "const Error = (msg: string) =>\n  <div style={{\n    backgroundColor: '#ffc0c0',\n    marginLeft: '10px',\n    marginRight: '10px',\n    padding: '10px',\n  }}>\n    <code>{msg}</code>\n  </div>",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'a',
          href: '/index',
          children: [
            {
              text: 'Jake Donham',
            },
          ],
        },
        {
          text: ' > ',
        },
        {
          type: 'a',
          href: '/blog/index',
          children: [
            {
              text: 'Technical Difficulties',
            },
          ],
        },
        {
          text: ' > How to run Electron on Linux on Docker on Mac',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'How to run Electron on Linux on Docker on Mac',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-02-18',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'My co-Recurser Hazem tried running ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/programmable-matter',
          children: [
            {
              text: 'Programmable Matter',
            },
          ],
        },
        {
          text: " on Linux, and it didn't work very well (I had previously run it only on my Mac). So the past few days I have been getting it running on Linux on ",
        },
        {
          type: 'a',
          href: 'https://www.docker.com/',
          children: [
            {
              text: 'Docker',
            },
          ],
        },
        {
          text: ' in order to fix it. I had not used Docker before so this was an adventure! I learned a lot.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Docker lets you run virtual computers (I'll call them ",
        },
        {
          text: 'guests',
          italic: true,
        },
        {
          text: ', although this is not ',
        },
        {
          type: 'a',
          href: 'https://docs.docker.com/glossary/',
          children: [
            {
              text: 'official Docker terminology',
            },
          ],
        },
        {
          text: ') inside your computer (the ',
        },
        {
          text: 'host',
          italic: true,
        },
        {
          text: "), and guests can run different operating systems from the one the host runs. You can use it to develop and test software on other OSes (or different versions of your host OS); or to bundle up a bunch of software packages so users can install and uninstall them all together; or to run programs in a restricted environment so they can't damage the host.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'I have a vague idea how this all works but I still find it extremely magical! Docker seems to be very well put together and everything worked really smoothly for me. Nonetheless I ran into a lot of puzzling stuff and did a whole lot of Googling to get it working. Mostly why this was complicated is that Programmable Matter is based on ',
        },
        {
          type: 'a',
          href: 'https://www.electronjs.org/',
          children: [
            {
              text: 'Electron',
            },
          ],
        },
        {
          text: ', which makes some unusual demands of the operating system it runs on.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Here is what I needed to do at a high level:',
        },
      ],
    },
    {
      type: 'ul',
      children: [
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'learn about Docker. I went through the ',
                },
                {
                  type: 'a',
                  href: 'https://docs.docker.com/get-started/',
                  children: [
                    {
                      text: 'getting started',
                    },
                  ],
                },
                {
                  text: ' tutorial, it was great.',
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'build an ',
                },
                {
                  text: 'image',
                  italic: true,
                },
                {
                  text: ' containing the base Linux installation and any extra libraries needed to run my app. (To run a guest computer you load an image into a ',
                },
                {
                  text: 'container',
                  italic: true,
                },
                {
                  text: '.)',
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'set things up so that the app running on the guest can display a window on my Mac.',
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'figure out some Docker security stuff.',
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'run the app!',
                },
              ],
            },
          ],
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Building a Docker image',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To build an image, you write a ',
        },
        {
          text: 'Dockerfile',
          code: true,
        },
        {
          text: ", which is a script of actions that modify the guest computer's storage; when the script finishes, the storage is snapshotted into a file on the host. Here's the one I wrote (with explanations interpolated):",
        },
      ],
    },
    {
      type: 'code',
      language: 'docker',
      children: [
        {
          text: 'FROM node:14',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This line names a base image to start with. Docker has a ',
        },
        {
          type: 'a',
          href: 'https://hub.docker.com/',
          children: [
            {
              text: 'repository of images',
            },
          ],
        },
        {
          text: ' of various base operating systems and add-ons. This one is a Debian image with Node.js version 14 installed (see ',
        },
        {
          type: 'a',
          href: 'https://hub.docker.com/_/node',
          children: [
            {
              text: 'https://hub.docker.com/_/node',
            },
          ],
        },
        {
          text: '). There are a bunch of choices here: for example, the sample app in the tutorial uses an image with Node on top of Alpine Linux, which is a lot smaller than Debian. (I picked ',
        },
        {
          text: 'node:14',
          code: true,
        },
        {
          text: ' because the smaller ones sounded from the docs like they might not work for me, but I should go back and try it.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'From this point on in the ',
        },
        {
          text: 'Dockerfile',
          code: true,
        },
        {
          text: ' you can run ordinary shell commands in the context of the guest:',
        },
      ],
    },
    {
      type: 'code',
      language: 'bash',
      children: [
        {
          text: '# stuff needed to get Electron to run\nRUN apt-get update && apt-get install \\\n    git libx11-xcb1 libxcb-dri3-0 libxtst6 libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 \\\n    -yq --no-install-suggests --no-install-recommends \\\n    && apt-get clean && rm -rf /var/lib/apt/lists/*',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The base images are typically pretty stripped down compared to a normal OS installation. In particular, ',
        },
        {
          text: 'node:14',
          code: true,
        },
        {
          text: ' is missing a bunch of libraries that Electron depends on for rendering the display. I found these by trying to start the app, getting an error like',
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: "Error('libX11-xcb.so.1: cannot open shared object file: No such file or directory')",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'searching for the missing library at ',
        },
        {
          type: 'a',
          href: 'https://www.debian.org/distrib/packages#search_contents',
          children: [
            {
              text: 'https://www.debian.org/distrib/packages#search_contents',
            },
          ],
        },
        {
          text: ', and adding the matching package. (',
        },
        {
          text: 'Git',
          code: true,
        },
        {
          text: ' is needed by ',
        },
        {
          type: 'a',
          href: 'https://www.electronforge.io/',
          children: [
            {
              text: 'electron-forge',
              code: true,
            },
          ],
        },
        {
          text: ", which I'm using to run my app.)",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "# Electron doesn't like to run as root\nRUN useradd -d /programmable-matter programmable-matter\nUSER programmable-matter",
        },
      ],
      language: 'docker',
    },
    {
      type: 'p',
      children: [
        {
          text: 'If you try to run Electron as root you get',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'inlineLiveCode',
          children: [
            {
              text: "Error('Running as root without --no-sandbox is not supported.')",
            },
          ],
        },
        {
          text: '',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'so we need to add a user (more about ',
        },
        {
          text: '--no-sandbox',
          code: true,
        },
        {
          text: ' below). The ',
        },
        {
          text: 'USER',
          code: true,
        },
        {
          text: ' command changes to the given user for subsequent commands.',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'WORKDIR /programmable-matter\nCOPY . .\nRUN npm install\nRUN npx electron-rebuild',
        },
      ],
      language: 'docker',
    },
    {
      type: 'p',
      children: [
        {
          text: 'The ',
        },
        {
          text: 'WORKDIR',
          code: true,
        },
        {
          text: ' command sets the working directory for subsequent commands, then ',
        },
        {
          text: 'COPY',
          code: true,
        },
        {
          text: ' copies a file tree containing the app code from the host filesystem to the guest filesystem. This includes ',
        },
        {
          text: 'package.json',
          code: true,
        },
        {
          text: ', so we can run ',
        },
        {
          text: 'npm install',
          code: true,
        },
        {
          text: '. We also run ',
        },
        {
          text: 'electron-rebuild',
          code: true,
        },
        {
          text: ' which builds some native code modules to match the installed Electron version. (',
        },
        {
          text: 'Electron-rebuild',
          code: true,
        },
        {
          text: ' is run by ',
        },
        {
          text: 'electron-forge',
          code: true,
        },
        {
          text: " on launch if we don't do it here, but that causes a Docker security issue, see below; and also makes startup slower, so I moved it here.)",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '# Electron needs root for sandboxing\n# see https://github.com/electron/electron/issues/17972\nUSER root\nRUN chown root /programmable-matter/node_modules/electron/dist/chrome-sandbox\nRUN chmod 4755 /programmable-matter/node_modules/electron/dist/chrome-sandbox',
        },
      ],
      language: 'docker',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Without this the app errors out with',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'inlineLiveCode',
          children: [
            {
              text: "Error('The SUID sandbox helper binary was found, but is not configured correctly.')",
            },
          ],
        },
        {
          text: '',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'As far as I understand things: Electron is based on Chromium, which has a fancy ',
        },
        {
          type: 'a',
          href: 'http://www.chromium.org/developers/design-documents/multi-process-architecture',
          children: [
            {
              text: 'multi-process architecture',
            },
          ],
        },
        {
          text: ' in which some processes are run with restricted permissions ("sandboxed"). Sandboxing can be done with a Linux kernel facility called "user namespaces", but this facility is not enabled on some Linux distributions, so there is a workaround using a setuid helper program. However ',
        },
        {
          text: 'npm install',
          code: true,
        },
        {
          text: " can't set the setuid bit without root permission, and the Electron package ",
        },
        {
          type: 'a',
          href: 'https://github.com/electron/electron/issues/17972',
          children: [
            {
              text: 'chooses not to ask for it',
            },
          ],
        },
        {
          text: ", so we need to do it explicitly. (I'm not sure whether user namespaces can be enabled on the Debian base image I started with, but I think it may use an older kernel version and this is a fairly recent feature.)",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'USER programmable-matter\nCMD npm run start',
        },
      ],
      language: 'docker',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now we are ready to build the image with',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'docker build -t programmable-matter .',
          code: true,
        },
      ],
      language: 'bash',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and run it with',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'docker run programmable-matter',
          code: true,
        },
      ],
      language: 'bash',
    },
    {
      type: 'p',
      children: [
        {
          text: 'But we get an error:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'inlineLiveCode',
          children: [
            {
              text: "Error('Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted.')",
            },
          ],
        },
        {
          text: ' ',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'XQuartz and DISPLAY',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'I like long specific error messages like this, they are easy to Google. I found ',
        },
        {
          type: 'a',
          href: 'https://stackoverflow.com/a/53975412/205191',
          children: [
            {
              text: 'this',
            },
          ],
        },
        {
          text: ', which suggests either passing the ',
        },
        {
          text: '--no-sandbox',
          code: true,
        },
        {
          text: ' argument or setting up a custom ',
        },
        {
          text: 'seccomp',
          code: true,
        },
        {
          text: ' configuration. I was feeling tired and not very interested in setting up a custom configuration for something I had never heard of, so I tried ',
        },
        {
          text: '--no-sandbox',
          code: true,
        },
        {
          text: ', which got me past the namespace error and on to a new one:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'inlineLiveCode',
          children: [
            {
              text: "Error('The futex facility returned an unexpected error code.')",
            },
          ],
        },
        {
          text: '',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Not very helpful—I was expecting this to be hard to Google, but ',
        },
        {
          type: 'a',
          href: 'https://github.com/electron/electron/issues/24211',
          children: [
            {
              text: 'this Electron issue',
            },
          ],
        },
        {
          text: ' was the second hit. Turns out I needed to set the ',
        },
        {
          text: 'DISPLAY',
          code: true,
        },
        {
          text: ' environment variable so Electron knows where to render its windows, using ',
        },
        {
          type: 'a',
          href: 'https://en.wikipedia.org/wiki/X_Window_System',
          children: [
            {
              text: 'X',
            },
          ],
        },
        {
          text: ', the standard windowing system on Linux.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'My Mac is running an implementation of the X display server, ',
        },
        {
          type: 'a',
          href: 'https://www.xquartz.org/',
          children: [
            {
              text: 'XQuartz',
            },
          ],
        },
        {
          text: ", which can receive connections from X programs and render their windows. When you're running an X client and server on the same computer they normally connect over a Unix socket for performance (and also for security). I tried to mount the X Unix socket from the host to the guest, following ",
        },
        {
          type: 'a',
          href: 'https://blog.jessfraz.com/post/docker-containers-on-the-desktop/',
          children: [
            {
              text: 'this post',
            },
          ],
        },
        {
          text: ', but I got several variations of',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'inlineLiveCode',
          children: [
            {
              text: "Error('docker: Error response from daemon: invalid mode: /tmp/.X11-unix')",
            },
          ],
        },
        {
          text: '',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'It turns out that mounting arbitrary Unix sockets into a container is ',
        },
        {
          type: 'a',
          href: 'https://github.com/docker/for-mac/issues/483',
          children: [
            {
              text: 'not supported on Docker for Mac',
            },
          ],
        },
        {
          text: '. Instead (following these ',
        },
        {
          type: 'a',
          href: 'https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949',
          children: [
            {
              text: 'instructions',
            },
          ],
        },
        {
          text: ') I set an XQuartz preference to allow connections from network clients, ran ',
        },
        {
          text: 'xhost +localhost',
          code: true,
        },
        {
          text: ' to allow connections from ',
        },
        {
          text: 'localhost',
          code: true,
        },
        {
          text: ', and ran ',
        },
        {
          text: 'docker',
          code: true,
        },
        {
          text: ' like so:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'docker run -e DISPLAY=host.docker.internal:0 programmable-matter',
          code: true,
        },
      ],
      language: 'bash',
    },
    {
      type: 'p',
      children: [
        {
          text: 'It works! The guest OS can reach network ports on the host at ',
        },
        {
          text: 'host.docker.internal',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: '-e DISPLAY=',
          code: true,
        },
        {
          text: ' passes the environment variable to the ',
        },
        {
          text: 'CMD',
          code: true,
        },
        {
          text: ' in the ',
        },
        {
          text: 'Dockerfile',
          code: true,
        },
        {
          text: '. I also needed to run ',
        },
        {
          text: 'xhost +localhost',
          code: true,
        },
        {
          text: ' so XQuartz will accept the connection. This is not secure for general use (XQuartz trusts the IP address of the incoming connection), but it seems OK for local use.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Docker and seccomp',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'After a rest on the fainting couch, I decided to try to set up ',
        },
        {
          text: 'seccomp',
          code: true,
        },
        {
          text: ' in order to get rid of the ',
        },
        {
          text: '--no-sandbox',
          code: true,
        },
        {
          text: ' argument. I am not sure how much practical value this has, since the whole app is running in a container, but maybe it prevents dangerous access between app processes in the container. In any case ',
        },
        {
          text: '--no-sandbox',
          code: true,
        },
        {
          text: ' seems like an escape-hatch flag that should be avoided. So following ',
        },
        {
          type: 'a',
          href: 'https://stackoverflow.com/a/53975412/205191',
          children: [
            {
              text: 'these instructions',
            },
          ],
        },
        {
          text: ' I tried running the container like so:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'docker run -e DISPLAY=host.docker.internal:0 --security-opt seccomp=chrome.json programmable-matter',
          code: true,
        },
      ],
      language: 'bash',
    },
    {
      type: 'p',
      children: [
        {
          text: 'where ',
        },
        {
          type: 'a',
          href: 'https://github.com/jessfraz/dotfiles/blob/master/etc/docker/seccomp/chrome.json',
          children: [
            {
              text: 'chrome.json',
              code: true,
            },
          ],
        },
        {
          text: " is from Jessie Frazelle's ",
        },
        {
          type: 'a',
          href: 'https://github.com/jessfraz/dotfiles/',
          children: [
            {
              text: 'dotfiles',
            },
          ],
        },
        {
          text: ' (see also ',
        },
        {
          type: 'a',
          href: 'https://blog.jessfraz.com/post/how-to-use-new-docker-seccomp-profiles/',
          children: [
            {
              text: 'how it was made',
            },
          ],
        },
        {
          text: '). As far as I understand things, ',
        },
        {
          type: 'a',
          href: 'https://docs.docker.com/engine/security/seccomp/',
          children: [
            {
              text: 'seccomp',
              code: true,
            },
          ],
        },
        {
          text: ' configures a list of Linux system calls that programs running on the guest are allowed to call, and ',
        },
        {
          text: 'chrome.json',
          code: true,
        },
        {
          text: ' includes the namespace calls Chromium uses for sandboxing. But:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'inlineLiveCode',
          children: [
            {
              text: "Error(\"EPERM: operation not permitted, copyfile '/programmable-matter/node_modules/nsfw/build/Release/nsfw.node' -> '/programmable-matter/node_modules/nsfw/bin/linux-x64-80/nsfw.node'\")",
            },
          ],
        },
        {
          text: '',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "The file in question is part of a native library I'm using, ",
        },
        {
          type: 'a',
          href: 'https://github.com/Axosoft/nsfw',
          children: [
            {
              text: 'NSFW',
            },
          ],
        },
        {
          text: ', and the error comes up while ',
        },
        {
          text: 'electron-forge',
          code: true,
        },
        {
          text: ' is running ',
        },
        {
          text: 'electron-rebuild',
          code: true,
        },
        {
          text: '. I thought that ',
        },
        {
          text: 'copyfile',
          code: true,
        },
        {
          text: ' was the name of a system call so I tried adding it to ',
        },
        {
          text: 'chrome.json',
          code: true,
        },
        {
          text: ", but that didn't work. I did find ",
        },
        {
          type: 'a',
          href: 'https://man7.org/linux/man-pages/man2/copy_file_range.2.html',
          children: [
            {
              text: 'copy_file_range',
              code: true,
            },
          ],
        },
        {
          text: ', however, and adding that one worked! I spent some time digging to find where the string ',
        },
        {
          text: 'copyfile',
          code: true,
        },
        {
          text: ' comes from (',
        },
        {
          text: 'electron-forge',
          code: true,
        },
        {
          text: ' calls ',
        },
        {
          text: 'electron-rebuild',
          code: true,
        },
        {
          text: ' calls ',
        },
        {
          text: 'node-gyp',
          code: true,
        },
        {
          text: ' which I think generates and runs a ',
        },
        {
          text: 'Makefile',
          code: true,
        },
        {
          text: ') but gave up.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Finally I realized that ',
        },
        {
          text: 'electron-rebuild',
          code: true,
        },
        {
          text: ' can be run at image build time instead of container run time; now the original ',
        },
        {
          text: 'chrome.json',
          code: true,
        },
        {
          text: ' works. So I guess there is no ',
        },
        {
          text: 'seccomp',
          code: true,
        },
        {
          text: ' restriction at image build time.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'The end',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Truly, friends, we live in a time of wonders! Please ',
        },
        {
          type: 'a',
          href: 'mailto:jake@donham.org',
          children: [
            {
              text: 'email me',
            },
          ],
        },
        {
          text: ' with comments, criticisms, corrections.',
        },
      ],
    },
  ],
  meta: {
    layout: '/layout',
    title: 'How to run Electron on Linux on Docker on Mac',
    publish: 'true',
  },
}
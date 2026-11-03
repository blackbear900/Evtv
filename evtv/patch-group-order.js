// Run once while building the image: makes NodeCast sort channel groups with evtv-groups.js instead of A to Z.
// Stops the build if NodeCast's code has changed and a patch no longer fits.
const fs = require('fs');

function patch(file, from, to) {
  const text = fs.readFileSync(file, 'utf8');
  if (text.split(from).length !== 2) throw new Error(`patch-group-order: expected text not found exactly once in ${file}`);
  fs.writeFileSync(file, text.replace(from, () => to));
}

// Load the group order (written by run.sh) and the sorting rule before the channel list
patch('/app/public/index.html',
  '  <script src="/js/components/ChannelList.js?v=3"></script>',
  '  <script src="/js/evtv-group-order.js"></script>\n' +
  '  <script src="/js/evtv-groups.js"></script>\n' +
  '  <script src="/js/components/ChannelList.js?v=3"></script>');

// Channel list (Favorites stays on top)
patch('/app/public/js/components/ChannelList.js',
  '            return a.localeCompare(b);\n        });',
  '            return window.evtvCompareGroups(a, b);\n        });');

// Group filter in the TV guide
patch('/app/public/js/components/EpgGuide.js',
  "m.sourceChannel.groupTitle || 'Uncategorized'))].sort();",
  "m.sourceChannel.groupTitle || 'Uncategorized'))].sort(window.evtvCompareGroups);");

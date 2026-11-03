// EV TV: show channel groups in the order typed in the add-on's "group_order" option.
// A group goes where the first word that's part of its name is listed; groups not listed follow, A to Z.
window.evtvCompareGroups = function (a, b) {
  const order = window.EVTV_GROUP_ORDER || [];
  const rank = name => {
    const i = order.findIndex(word => String(name).toLowerCase().includes(word));
    return i === -1 ? order.length : i;
  };
  return rank(a) - rank(b) || String(a).localeCompare(String(b));
};

// Atelier — Year-in-pocket. The 2026 north star lives inside each pocket card
// on home, and as a stack of banner headers on the detail screen.
//
// This file is THE app: a single interactive prototype with routing,
// settings, theme toggle, font scale, reset, and the tick strip.
//
// Exports: window.AtelierYear

const YEAR_PALETTES = {
  light: {
    bg: '#ffffff', ink: '#0a0a0a', sub: '#525252', mute: '#a3a3a3',
    rule: '#ededed', ruleHi: '#0a0a0a', accent: '#0a0a0a',
    chip: '#fafafa', pocket: '#ffffff', surface: '#fafafa',
    starBg: '#ededed', starBorder: '#dcdcdc', starInk: '#0a0a0a',
    yearBg: '#f5f5f2', yearInk: '#0a0a0a',
  },
  dark: {
    bg: '#121212', ink: '#ffffff', sub: '#a7a7a7', mute: '#727272',
    rule: '#2a2a2a', ruleHi: '#ffffff', accent: '#1ed760',
    chip: '#1f1f1f', pocket: '#181818', surface: '#181818',
    starBg: '#282828', starBorder: '#3e3e3e', starInk: '#ffffff',
    yearBg: '#181818', yearInk: '#ffffff',
  },
};

const YEAR_DISPLAY = '"Fraunces", "Instrument Serif", Georgia, serif';
const YEAR_SANS = '"Inter", ui-sans-serif, system-ui, sans-serif';
const YEAR_MONO = '"JetBrains Mono", ui-monospace, monospace';

const Y_AREAS_DEFAULT = ['Work', 'Body', 'Mind', 'Skill', 'Daily', 'Play', 'Life', 'Open'];

const Y_INITIAL_GOALS = [
  { id: 1,  area: 'Work',  title: 'Ship side project v0.1', star: true,  addedDay: 1 },
  { id: 2,  area: 'Work',  title: '€500 to brokerage',      star: false, addedDay: 3 },
  { id: 3,  area: 'Body',  title: 'Sub-25 5K',              star: true,  addedDay: 1 },
  { id: 4,  area: 'Body',  title: 'Strength 3×/wk',         star: false, addedDay: 1 },
  { id: 5,  area: 'Body',  title: 'Long run Sat',           star: false, addedDay: 6 },
  { id: 6,  area: 'Mind',  title: 'Beginning of Infinity',  star: true,  addedDay: 2 },
  { id: 7,  area: 'Mind',  title: 'Severance S2',           star: false, addedDay: 4 },
  { id: 8,  area: 'Skill', title: 'Rust ownership',         star: true,  addedDay: 1 },
  { id: 9,  area: 'Skill', title: 'Italian A2',             star: false, addedDay: 5 },
  { id:10,  area: 'Skill', title: 'Tonal harmony',          star: false, addedDay: 8 },
  { id:11,  area: 'Daily', title: 'Read 20m before bed',    star: true,  addedDay: 1 },
  { id:12,  area: 'Daily', title: 'No phone before 9am',    star: false, addedDay: 1 },
  { id:13,  area: 'Play',  title: 'Silksong',               star: false, addedDay: 7 },
  { id:14,  area: 'Life',  title: 'Renew passport',         star: true,  addedDay: 2 },
  { id:15,  area: 'Life',  title: 'Lisbon trip',            star: false, addedDay: 9 },
];

// ─── ROOT ────────────────────────────────────────────────────────────
function AtelierYear() {
  const [theme, setTheme] = React.useState('light');
  const [fontScale, setFontScale] = React.useState('M');
  const [route, setRoute] = React.useState({ name: 'home' });
  const [settingsOpen, setSettingsOpen] = React.useState(false);

  // Editable, persisted-ish state (in-memory; reset clears it)
  const [areas, setAreas] = React.useState(Y_AREAS_DEFAULT);
  const [goals, setGoals] = React.useState(Y_INITIAL_GOALS);
  const [yearGoalsState, setYearGoalsState] = React.useState(
    () => YEAR_GOALS.map((g) => ({ ...g, expanded: true }))
  );

  const C = YEAR_PALETTES[theme];
  const fontPct = fontScale === 'S' ? 0.92 : fontScale === 'L' ? 1.10 : 1;

  const yearsByArea = (area) => yearGoalsState.filter((g) => g.area === area);

  const toggleYearExpand = (id) =>
    setYearGoalsState((gs) => gs.map((g) =>
      g.id === id ? { ...g, expanded: !g.expanded } : g));
  const removeYear = (id) =>
    setYearGoalsState((gs) => gs.filter((g) => g.id !== id));

  const addYearGoal = (area, title) => {
    if (!title.trim()) return;
    setYearGoalsState((gs) => [...gs, {
      id: Date.now(), area, title: title.trim(), expanded: true,
    }]);
  };

  const addGoal = (area, title) => {
    if (!title.trim()) return;
    setGoals((gs) => [...gs, {
      id: Date.now(), area, title: title.trim(), star: false,
      addedDay: dayOfMonth,
    }]);
  };
  const removeGoal = (id) => setGoals((gs) => gs.filter((g) => g.id !== id));
  const updateGoal = (id, patch) =>
    setGoals((gs) => gs.map((g) => g.id === id ? { ...g, ...patch } : g));
  const toggleStar = (id) => setGoals((gs) =>
    gs.map((g) => g.id === id ? { ...g, star: !g.star } : g));

  const removeArea = (name) => {
    setAreas((a) => a.filter((x) => x !== name));
    setGoals((gs) => gs.filter((g) => g.area !== name));
    setYearGoalsState((ys) => ys.filter((y) => y.area !== name));
  };

  const reorderArea = (from, to) => {
    setAreas((a) => {
      if (from === to || from < 0 || to < 0 || from >= a.length || to >= a.length) return a;
      const next = a.slice();
      const [moved] = next.splice(from, 1);
      next.splice(to, 0, moved);
      return next;
    });
  };

  const resetAll = () => {
    setTheme('light');
    setFontScale('M');
    setAreas(Y_AREAS_DEFAULT);
    setGoals(Y_INITIAL_GOALS);
    setYearGoalsState(YEAR_GOALS.map((g) => ({ ...g, expanded: true })));
    setRoute({ name: 'home' });
    setSettingsOpen(false);
    try {
      localStorage.removeItem('atelier:yearbanner:expanded:v1');
      localStorage.removeItem('atelier:yearbanner:removed:v1');
    } catch (e) {}
  };

  const ctx = {
    C, theme, setTheme, fontScale, setFontScale,
    areas, goals, yearGoalsState, yearsByArea,
    toggleYearExpand, removeYear, addYearGoal,
    addGoal, removeGoal, updateGoal, toggleStar,
    removeArea, reorderArea,
    route, setRoute, settingsOpen, setSettingsOpen, resetAll,
  };

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: YEAR_SANS, position: 'relative',
      transition: 'background .25s, color .25s',
      fontSize: `${16 * fontPct}px`,
    }}>
      <YStatusBar C={C} />
      {route.name === 'home'
        ? <YHome {...ctx} />
        : <YDetail {...ctx} area={route.area} />}
      {settingsOpen && (
        <YSettingsSheet
          C={C} theme={theme} setTheme={setTheme}
          fontScale={fontScale} setFontScale={setFontScale}
          onReset={resetAll} onClose={() => setSettingsOpen(false)}
        />
      )}
    </div>
  );
}

// ─── STATUS BAR ──────────────────────────────────────────────────────
function YStatusBar({ C }) {
  return (
    <div style={{
      height: 36, padding: '0 22px', display: 'flex',
      alignItems: 'center', justifyContent: 'space-between',
      fontSize: 13, fontWeight: 600, color: C.ink, flexShrink: 0,
    }}>
      <span>9:41</span>
      <span style={{ fontSize: 11, opacity: 0.7 }}>●●●● · 86%</span>
    </div>
  );
}

// ─── TICK STRIP ──────────────────────────────────────────────────────
function YTickStrip({ C }) {
  const total = MONTH.daysInMonth;
  const pct = Math.round((dayOfMonth / total) * 100);
  const todayLeftPct = ((dayOfMonth - 1) / (total - 1)) * 100;
  return (
    <div style={{ position: 'relative', height: 22 }}>
      {/* tiny label above today's tick */}
      <div style={{
        position: 'absolute',
        left: `${todayLeftPct}%`, top: -2,
        transform: 'translateX(-50%)',
        fontFamily: YEAR_MONO, fontSize: 8.5,
        letterSpacing: 1.2, color: C.ink, fontWeight: 600,
        whiteSpace: 'nowrap',
      }}>
        D{dayOfMonth}
        <span style={{ color: C.mute, fontWeight: 500, marginLeft: 4 }}>
          · {pct}%
        </span>
      </div>

      {/* baseline */}
      <div style={{
        position: 'absolute', left: 0, right: 0, top: 13,
        height: 1, background: C.rule,
      }}/>
      {Array.from({ length: total }).map((_, i) => {
        const day = i + 1;
        const isToday = day === dayOfMonth;
        const isMajor = day % 5 === 0 || day === 1 || day === total;
        return (
          <div key={i} style={{
            position: 'absolute',
            left: `${(i / (total - 1)) * 100}%`,
            top: 13, transform: 'translate(-50%, 0)',
            width: isToday ? 2 : 1,
            height: isToday ? 14 : (isMajor ? 6 : 3),
            background: isToday ? C.accent : C.rule,
          }}/>
        );
      })}
    </div>
  );
}

// ─── HOME ────────────────────────────────────────────────────────────
function YHome(ctx) {
  const { C, areas, goals, yearsByArea, setRoute, setSettingsOpen,
          removeArea, reorderArea } = ctx;
  const [manage, setManage] = React.useState(false);
  const [dragIdx, setDragIdx] = React.useState(null);   // index being dragged
  const [overIdx, setOverIdx] = React.useState(null);   // target index

  const pockets = areas.map((area) => {
    const all = yearsByArea(area);
    return {
      area,
      items: goals.filter((g) => g.area === area),
      visibleYears: all.filter((y) => y.expanded),
      hiddenCount: all.filter((y) => !y.expanded).length,
      totalYears: all.length,
    };
  });
  // The "Open" pocket is the add-new affordance — exclude it while
  // in manage mode so it can't be reordered or deleted.
  const visiblePockets = manage
    ? pockets.filter((p) => p.area !== 'Open')
    : pockets;

  // Long-press detection — fires on the pocket; YHome receives the trigger
  // through a callback. Tapping outside any pocket exits manage mode.
  const handleBackgroundClick = (e) => {
    if (manage) setManage(false);
  };

  // Drag handlers — track by area name so reorder works even when
  // some pockets are filtered out of view (e.g. "Open" in manage mode).
  const onDragStart = (area) => () => setDragIdx(area);
  const onDragOver = (area) => (e) => {
    e.preventDefault();
    if (dragIdx == null || area === dragIdx) return;
    setOverIdx(area);
  };
  const onDrop = (area) => (e) => {
    e.preventDefault();
    if (dragIdx != null && dragIdx !== area) {
      const from = areas.indexOf(dragIdx);
      const to = areas.indexOf(area);
      reorderArea(from, to);
    }
    setDragIdx(null); setOverIdx(null);
  };
  const onDragEnd = () => { setDragIdx(null); setOverIdx(null); };

  return (
    <>
      {/* Top bar — month title + days left + settings */}
      <div style={{ padding: '14px 22px 16px', flexShrink: 0 }}
        onClick={handleBackgroundClick}>
        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          marginBottom: 14,
        }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
            <span style={{
              fontFamily: YEAR_DISPLAY, fontSize: 24, fontStyle: 'italic',
              fontWeight: 400, letterSpacing: -0.5, color: C.ink,
            }}>May</span>
            <span style={{
              fontFamily: YEAR_MONO, fontSize: 10, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>2026</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            {manage ? (
              <button onClick={(e) => { e.stopPropagation(); setManage(false); }}
                style={{
                  background: C.ink, color: C.bg, border: 'none',
                  padding: '5px 12px', borderRadius: 999,
                  fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.4,
                  textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
                }}>Done</button>
            ) : (
              <>
                <span style={{
                  fontFamily: YEAR_MONO, fontSize: 10, color: C.sub,
                  letterSpacing: 1.4,
                }}>
                  <span style={{ color: C.ink, fontWeight: 600 }}>{daysLeft}</span>
                  <span style={{ color: C.mute }}> DAYS LEFT</span>
                </span>
                <button onClick={(e) => { e.stopPropagation(); setSettingsOpen(true); }}
                  aria-label="settings"
                  style={{
                    background: 'transparent', border: `1px solid ${C.rule}`,
                    color: C.sub, width: 26, height: 26, borderRadius: 999,
                    fontSize: 13, cursor: 'pointer', display: 'flex',
                    alignItems: 'center', justifyContent: 'center', padding: 0,
                    lineHeight: 1,
                  }}>⚙</button>
              </>
            )}
          </div>
        </div>
        <YTickStrip C={C} />
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '4px 22px 20px' }}
        onClick={handleBackgroundClick}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}
          onClick={(e) => e.stopPropagation()}>
          {visiblePockets.map((p) => (
            <YPocket key={p.area} p={p} C={C}
              manage={manage}
              isDragging={dragIdx === p.area}
              isOver={overIdx === p.area && dragIdx !== null && dragIdx !== p.area}
              onLongPress={() => {
                if (p.area === 'Open') return; // can't manage Open
                setManage(true);
              }}
              onOpen={() => {
                if (manage) return;
                setRoute({ name: 'detail', area: p.area });
              }}
              onRemove={() => removeArea(p.area)}
              onDragStart={onDragStart(p.area)}
              onDragOver={onDragOver(p.area)}
              onDrop={onDrop(p.area)}
              onDragEnd={onDragEnd}
            />
          ))}
        </div>

        {manage && (
          <div style={{
            marginTop: 14, padding: '8px 6px', textAlign: 'center',
            fontFamily: YEAR_MONO, fontSize: 9, color: C.mute,
            letterSpacing: 1.4, textTransform: 'uppercase',
          }}>Drag to reorder · Tap × to remove · Tap outside to finish</div>
        )}
      </div>
    </>
  );
}

function YPocket({ p, C, onOpen, manage, isDragging, isOver,
                   onLongPress, onRemove,
                   onDragStart, onDragOver, onDrop, onDragEnd }) {
  const empty = p.items.length === 0;
  const lpRef = React.useRef(null);
  const moved = React.useRef(false);

  const startLP = (e) => {
    if (manage) return;
    moved.current = false;
    clearTimeout(lpRef.current);
    lpRef.current = setTimeout(() => {
      onLongPress();
    }, 450);
  };
  const cancelLP = () => clearTimeout(lpRef.current);
  const onPointerMove = () => {
    if (!moved.current) {
      moved.current = true;
      cancelLP();
    }
  };

  return (
    <div
      onClick={(e) => {
        // when in manage mode, swallow the click so the background
        // dismisser doesn't fire (and don't navigate)
        if (manage) { e.stopPropagation(); return; }
        onOpen();
      }}
      onPointerDown={startLP}
      onPointerUp={cancelLP}
      onPointerLeave={cancelLP}
      onPointerCancel={cancelLP}
      onPointerMove={onPointerMove}
      draggable={manage}
      onDragStart={onDragStart}
      onDragOver={onDragOver}
      onDrop={onDrop}
      onDragEnd={onDragEnd}
      style={{
        background: C.pocket,
        border: `1px solid ${isOver ? C.ink : C.rule}`,
        borderRadius: 14,
        padding: '10px 10px', display: 'flex', flexDirection: 'column', gap: 6,
        minHeight: 130, minWidth: 0,
        cursor: manage ? 'grab' : 'pointer',
        opacity: isDragging ? 0.4 : 1,
        animation: manage ? 'yearWiggle .15s ease-in-out infinite alternate' : 'none',
        transition: 'border-color .15s, opacity .15s',
        position: 'relative',
      }}>
      {/* manage-mode remove button */}
      {manage && (
        <button onClick={(e) => { e.stopPropagation(); onRemove(); }}
          aria-label={`Remove ${p.area}`}
          style={{
            position: 'absolute', top: -6, left: -6, zIndex: 2,
            width: 20, height: 20, borderRadius: 10,
            background: C.ink, color: C.bg, border: `2px solid ${C.bg}`,
            cursor: 'pointer', padding: 0,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: YEAR_MONO, fontSize: 11, lineHeight: 1, fontWeight: 700,
            animation: 'none',
          }}>×</button>
      )}

      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        padding: '0 4px 4px',
      }}>
        <span style={{
          fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.8,
          textTransform: 'uppercase', color: C.sub, fontWeight: 600,
        }}>{p.area}</span>
        <span style={{
          fontFamily: YEAR_MONO, fontSize: 9, color: C.mute, letterSpacing: 1,
        }}>{empty ? '—' : String(p.items.length).padStart(2, '0')}</span>
      </div>

      {p.totalYears > 0 ? (
        <div style={{
          padding: '0 4px 6px', borderBottom: `1px dashed ${C.rule}`,
          marginBottom: 2,
        }}>
          <div style={{
            display: 'flex', alignItems: 'baseline',
            justifyContent: 'space-between', marginBottom: 2,
          }}>
            <span style={{
              fontFamily: YEAR_MONO, fontSize: 8, letterSpacing: 1.6,
              textTransform: 'uppercase', color: C.mute, fontWeight: 600,
            }}>2026</span>
            {p.totalYears > 1 && (
              <span style={{
                fontFamily: YEAR_MONO, fontSize: 8, letterSpacing: 1, color: C.mute,
              }}>×{p.totalYears}</span>
            )}
          </div>
          {p.visibleYears.slice(0, 2).map((y) => (
            <div key={y.id} style={{
              fontFamily: YEAR_DISPLAY, fontSize: 12, fontStyle: 'italic',
              lineHeight: 1.25, color: C.sub, fontWeight: 400,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>{y.title}</div>
          ))}
          {p.visibleYears.length === 0 && p.hiddenCount > 0 && (
            <div style={{
              fontFamily: YEAR_MONO, fontSize: 8.5, letterSpacing: 1.4,
              textTransform: 'uppercase', color: C.mute, fontWeight: 600,
              marginTop: 2,
            }}>{p.hiddenCount} collapsed</div>
          )}
          {p.visibleYears.length > 2 && (
            <div style={{
              fontFamily: YEAR_MONO, fontSize: 8, letterSpacing: 1, color: C.mute,
              marginTop: 2,
            }}>+{p.visibleYears.length - 2} more</div>
          )}
        </div>
      ) : (
        <div style={{
          padding: '4px 4px 6px', borderBottom: `1px dashed ${C.rule}`,
          marginBottom: 2, fontFamily: YEAR_MONO, fontSize: 8.5,
          letterSpacing: 1.4, textTransform: 'uppercase', color: C.mute,
        }}>no 2026 goal</div>
      )}

      {empty ? (
        <div style={{
          flex: 1, minHeight: 50,
          border: `1px dashed ${C.rule}`, borderRadius: 10,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: YEAR_MONO, fontSize: 9.5, color: C.mute,
          letterSpacing: 1.2, textTransform: 'uppercase',
        }}>{p.area === 'Open' ? 'Open · add' : 'Empty'}</div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
          {p.items.slice(0, 3).map((g) => (
            <div key={g.id} style={{
              background: g.star ? C.starBg : C.chip,
              border: `1px solid ${g.star ? C.starBorder : C.rule}`,
              borderRadius: 8, padding: '7px 10px',
              fontFamily: YEAR_DISPLAY, fontSize: 12.5, fontWeight: 400,
              letterSpacing: -0.2, lineHeight: 1.3,
              color: g.star ? C.starInk : C.ink,
              display: 'flex', alignItems: 'flex-start', gap: 6, minWidth: 0,
            }}>
              {g.star && <span style={{ color: C.starInk, fontSize: 9,
                flexShrink: 0, marginTop: 4 }}>★</span>}
              <span style={{
                minWidth: 0, display: '-webkit-box',
                WebkitLineClamp: 2, WebkitBoxOrient: 'vertical',
                overflow: 'hidden',
              }}>{g.title}</span>
            </div>
          ))}
          {p.items.length > 3 && (
            <div style={{
              fontFamily: YEAR_MONO, fontSize: 9, color: C.mute,
              letterSpacing: 1, padding: '2px 4px',
            }}>+{p.items.length - 3} more</div>
          )}
        </div>
      )}
    </div>
  );
}

// ─── DETAIL ──────────────────────────────────────────────────────────
function YDetail(ctx) {
  const { C, area, goals, yearsByArea, setRoute,
          toggleYearExpand, removeYear, addYearGoal,
          addGoal, removeGoal, updateGoal, toggleStar } = ctx;
  const yearGoals = yearsByArea(area);
  const items = goals.filter((g) => g.area === area);
  const [addTarget, setAddTarget] = React.useState('month');
  const [composing, setComposing] = React.useState(false);
  const [draft, setDraft] = React.useState('');

  const submit = () => {
    if (!draft.trim()) { setComposing(false); return; }
    if (addTarget === 'year') addYearGoal(area, draft);
    else addGoal(area, draft);
    setDraft('');
    setComposing(false);
  };

  return (
    <>
      <div style={{ padding: '14px 22px 10px', flexShrink: 0,
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
      }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
          <button onClick={() => setRoute({ name: 'home' })} style={{
            background: 'transparent', border: 'none', color: C.sub,
            cursor: 'pointer', padding: 0, marginRight: 4,
            fontFamily: YEAR_MONO, fontSize: 13, lineHeight: 1,
          }}>←</button>
          <span style={{
            fontFamily: YEAR_DISPLAY, fontSize: 24, fontStyle: 'italic',
            fontWeight: 400, letterSpacing: -0.5, color: C.ink,
          }}>{area}</span>
        </div>
        <span style={{
          fontFamily: YEAR_MONO, fontSize: 9.5, color: C.sub, letterSpacing: 1.4,
        }}>
          <span style={{ color: C.ink, fontWeight: 600 }}>{items.length}</span>
          <span style={{ color: C.mute }}> THIS MONTH</span>
        </span>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '0 0 90px' }}>
        <div style={{ padding: '4px 22px 0', display: 'flex',
          flexDirection: 'column', gap: 8 }}>
          {yearGoals.length === 0 && (
            <div style={{
              border: `1px dashed ${C.rule}`, borderRadius: 14,
              padding: '14px 16px', textAlign: 'center',
              fontFamily: YEAR_MONO, fontSize: 9.5, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>No 2026 goal yet for {area}</div>
          )}
          {yearGoals.map((yg) => (
            <YYearBanner key={yg.id} yg={yg} C={C}
              onToggle={() => toggleYearExpand(yg.id)}
              onRemove={() => removeYear(yg.id)} />
          ))}
        </div>

        <div style={{
          margin: '20px 22px 10px', display: 'flex',
          alignItems: 'baseline', justifyContent: 'space-between',
        }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.8,
            textTransform: 'uppercase', color: C.sub, fontWeight: 600,
          }}>this month · may</span>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9, color: C.mute, letterSpacing: 1,
          }}>{daysLeft} DAYS LEFT</span>
        </div>

        <div style={{ padding: '0 22px' }}>
          {items.length === 0 && (
            <div style={{
              padding: '20px 0', textAlign: 'center',
              fontFamily: YEAR_MONO, fontSize: 9.5, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>Nothing this month yet</div>
          )}
          {items.map((g, i) => (
            <YGoalRow key={g.id} g={g} C={C}
              isLast={i === items.length - 1}
              onToggleStar={() => toggleStar(g.id)}
              onUpdate={(patch) => updateGoal(g.id, patch)}
              onRemove={() => removeGoal(g.id)} />
          ))}
        </div>
      </div>

      {/* Add bar */}
      <div style={{
        position: 'absolute', left: 14, right: 14, bottom: 14,
        background: C.pocket, border: `1px solid ${C.rule}`,
        borderRadius: 14, padding: '6px 6px 6px 6px',
        display: 'flex', alignItems: 'center', gap: 6,
        boxShadow: '0 8px 24px rgba(0,0,0,0.06)',
      }}>
        <YAddTargetSwitch value={addTarget} onChange={setAddTarget} C={C} />
        {composing ? (
          <input autoFocus value={draft}
            onChange={(e) => setDraft(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') submit();
              if (e.key === 'Escape') { setDraft(''); setComposing(false); }
            }}
            onBlur={submit}
            placeholder={addTarget === 'month' ? `New ${area} goal…` : `New 2026 ${area} goal…`}
            style={{
              flex: 1, background: 'transparent', border: 'none',
              fontFamily: YEAR_DISPLAY, fontSize: 14, color: C.ink,
              outline: 'none', padding: '8px 6px',
            }}/>
        ) : (
          <button onClick={() => setComposing(true)} style={{
            flex: 1, background: 'transparent', border: 'none', cursor: 'pointer',
            fontFamily: YEAR_MONO, fontSize: 10, letterSpacing: 1.4,
            textTransform: 'uppercase', color: C.sub, fontWeight: 600,
            padding: '8px 6px', textAlign: 'left',
          }}>+ Add to {addTarget === 'month' ? area : '2026'}</button>
        )}
      </div>
    </>
  );
}

function YYearBanner({ yg, C, onToggle, onRemove }) {
  const expanded = yg.expanded;
  return (
    <div onClick={onToggle} style={{
      width: '100%',
      background: C.yearBg,
      border: `1px solid ${C.starBorder}`,
      borderRadius: expanded ? 14 : 10,
      padding: expanded ? '14px 16px 16px' : '10px 14px',
      transition: 'padding .2s ease, border-radius .2s ease',
      display: 'flex', flexDirection: 'column', cursor: 'pointer',
    }}>
      {expanded ? (
        <>
          <div style={{
            display: 'flex', justifyContent: 'space-between',
            alignItems: 'center', marginBottom: 8, gap: 10,
          }}>
            <span style={{
              fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.8,
              textTransform: 'uppercase', color: C.sub, fontWeight: 600,
            }}>2026 · north star</span>
            <button onClick={(e) => { e.stopPropagation(); onRemove(); }}
              aria-label="Remove year goal" style={{
                width: 24, height: 24, borderRadius: 12,
                background: C.chip, border: `1px solid ${C.rule}`,
                color: C.ink, cursor: 'pointer', padding: 0,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: YEAR_MONO, fontSize: 13, lineHeight: 1,
                fontWeight: 500,
              }}>×</button>
          </div>
          <div style={{
            fontFamily: YEAR_DISPLAY, fontSize: 20, lineHeight: 1.2,
            letterSpacing: -0.4, color: C.ink, fontWeight: 400,
          }}>{yg.title}</div>
        </>
      ) : (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10, minWidth: 0,
        }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 8.5, letterSpacing: 1.6,
            textTransform: 'uppercase', color: C.mute, fontWeight: 600,
            flexShrink: 0,
          }}>2026</span>
          <span style={{
            flex: 1, minWidth: 0,
            fontFamily: YEAR_DISPLAY, fontSize: 14, fontStyle: 'italic',
            letterSpacing: -0.2, color: C.ink, fontWeight: 400,
            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
          }}>{yg.title}</span>
        </div>
      )}
    </div>
  );
}

function YAddTargetSwitch({ value, onChange, C }) {
  const opts = [
    { v: 'month', label: 'May' },
    { v: 'year',  label: '2026' },
  ];
  return (
    <div style={{
      display: 'flex', background: C.chip,
      border: `1px solid ${C.rule}`, borderRadius: 9,
      padding: 2, gap: 0, flexShrink: 0,
    }}>
      {opts.map((o) => (
        <button key={o.v}
          onClick={(e) => { e.stopPropagation(); onChange(o.v); }}
          style={{
            background: value === o.v ? C.ink : 'transparent',
            color: value === o.v ? C.bg : C.sub,
            border: 'none', borderRadius: 7,
            fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.2,
            textTransform: 'uppercase', fontWeight: 600,
            padding: '6px 9px', cursor: 'pointer',
            transition: 'background .15s, color .15s',
          }}>{o.label}</button>
      ))}
    </div>
  );
}

function YGoalRow({ g, C, isLast, onToggleStar, onUpdate, onRemove }) {
  const [open, setOpen] = React.useState(false);
  const [editing, setEditing] = React.useState(false);
  const [title, setTitle] = React.useState(g.title);

  return (
    <div style={{
      padding: editing ? '12px 14px' : '16px 14px',
      margin: '0 -14px',
      borderRadius: g.star || open ? 12 : 0,
      background: g.star ? C.starBg : (open ? C.chip : 'transparent'),
      borderBottom: isLast ? 'none' : `1px solid ${(g.star || open) ? 'transparent' : C.rule}`,
      transition: 'background .15s ease',
    }}>
      {editing ? (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <input autoFocus value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Goal title"
            style={{
              background: C.bg, border: `1px solid ${C.rule}`, borderRadius: 8,
              padding: '10px 12px', fontFamily: YEAR_DISPLAY, fontSize: 17,
              color: C.ink, outline: 'none', letterSpacing: -0.3,
            }}/>
          <div style={{ display: 'flex', gap: 6, justifyContent: 'flex-end' }}>
            <button onClick={() => { setTitle(g.title); setEditing(false); }}
              style={{
                background: 'transparent', border: `1px solid ${C.rule}`,
                color: C.sub, padding: '6px 12px', borderRadius: 6,
                fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.4,
                textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
              }}>Cancel</button>
            <button onClick={() => { onUpdate({ title }); setEditing(false); }}
              style={{
                background: C.ink, color: C.bg, border: 'none',
                padding: '6px 12px', borderRadius: 6,
                fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.4,
                textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
              }}>Save</button>
          </div>
        </div>
      ) : (
        <>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10,
            cursor: 'pointer',
          }} onClick={() => setOpen(!open)}>
            <span onClick={(e) => { e.stopPropagation(); onToggleStar(); }}
              style={{
                color: g.star ? C.starInk : C.mute, fontSize: 12,
                padding: 2, lineHeight: 1, marginTop: 6, cursor: 'pointer',
              }}>{g.star ? '★' : '☆'}</span>

            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{
                fontFamily: YEAR_DISPLAY, fontSize: 17, fontWeight: 400,
                letterSpacing: -0.3, lineHeight: 1.2, color: C.ink,
              }}>{g.title}</div>
            </div>

            <div style={{
              fontFamily: YEAR_MONO, fontSize: 9, color: C.mute,
              letterSpacing: 1, textTransform: 'uppercase',
              marginTop: 8, whiteSpace: 'nowrap',
            }}>{(() => {
              const d = Math.max(0, dayOfMonth - g.addedDay);
              if (d === 0) return 'today';
              if (d === 1) return '1 day';
              return `${d} days`;
            })()}</div>
          </div>

          {open && (
            <div style={{
              marginTop: 10, paddingTop: 10, paddingLeft: 22,
              borderTop: `1px dashed ${C.rule}`,
              display: 'flex', gap: 8, alignItems: 'center',
              justifyContent: 'flex-end',
            }}>
              <button onClick={() => setEditing(true)} style={{
                background: 'transparent', border: `1px solid ${C.rule}`,
                color: C.sub, padding: '6px 12px', borderRadius: 6,
                fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.4,
                textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
              }}>Edit</button>
              <button onClick={() => {
                if (window.confirm('Remove this goal?')) onRemove();
              }} style={{
                background: 'transparent', border: `1px solid ${C.rule}`,
                color: '#b35454', padding: '6px 12px', borderRadius: 6,
                fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.4,
                textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
              }}>Remove</button>
            </div>
          )}
        </>
      )}
    </div>
  );
}

// ─── SETTINGS SHEET ──────────────────────────────────────────────────
function YSettingsSheet({ C, theme, setTheme, fontScale, setFontScale,
                          onReset, onClose }) {
  const [confirmReset, setConfirmReset] = React.useState(false);
  const isDark = theme === 'dark';

  const Segmented = ({ value, options, onChange }) => (
    <div style={{
      display: 'flex', background: C.surface, border: `1px solid ${C.rule}`,
      borderRadius: 999, padding: 2, gap: 2,
    }}>
      {options.map((o) => {
        const active = o.value === value;
        return (
          <button key={o.value} onClick={() => onChange(o.value)}
            style={{
              flex: 1, padding: '8px 14px', borderRadius: 999, border: 'none',
              background: active ? C.ink : 'transparent',
              color: active ? C.bg : C.sub,
              fontFamily: YEAR_MONO, fontSize: 10, letterSpacing: 1.4,
              textTransform: 'uppercase', fontWeight: 600,
              cursor: 'pointer', transition: 'background .15s, color .15s',
            }}>{o.label}</button>
        );
      })}
    </div>
  );

  return (
    <>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0, background: 'rgba(0,0,0,0.35)',
        zIndex: 50, animation: 'yearBackdropIn .2s ease-out',
      }}/>
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: C.bg, color: C.ink, zIndex: 51,
        borderTopLeftRadius: 22, borderTopRightRadius: 22,
        boxShadow: '0 -8px 30px rgba(0,0,0,0.18)',
        animation: 'yearSheetUp .25s cubic-bezier(.2,.8,.2,1)',
        padding: '12px 22px 28px', display: 'flex', flexDirection: 'column',
        gap: 22,
      }}>
        <div style={{
          width: 38, height: 4, background: C.rule, borderRadius: 999,
          alignSelf: 'center',
        }}/>

        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          marginTop: -6,
        }}>
          <span style={{
            fontFamily: YEAR_DISPLAY, fontSize: 24, fontStyle: 'italic',
            fontWeight: 400, letterSpacing: -0.5, color: C.ink,
          }}>Settings</span>
          <button onClick={onClose} style={{
            background: 'transparent', border: 'none', color: C.sub,
            fontFamily: YEAR_MONO, fontSize: 10, letterSpacing: 1.4,
            textTransform: 'uppercase', cursor: 'pointer', padding: 0,
          }}>Close</button>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9.5, color: C.mute,
            letterSpacing: 1.6, textTransform: 'uppercase',
          }}>Theme</span>
          <Segmented
            value={theme}
            onChange={setTheme}
            options={[
              { value: 'light', label: '☼  Light' },
              { value: 'dark',  label: '☾  Dark' },
            ]}
          />
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9.5, color: C.mute,
            letterSpacing: 1.6, textTransform: 'uppercase',
          }}>Font size</span>
          <Segmented
            value={fontScale}
            onChange={setFontScale}
            options={[
              { value: 'S', label: 'Small' },
              { value: 'M', label: 'Medium' },
              { value: 'L', label: 'Large' },
            ]}
          />
        </div>

        <div style={{ height: 1, background: C.rule, margin: '2px 0' }}/>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {!confirmReset ? (
            <button onClick={() => setConfirmReset(true)} style={{
              background: 'transparent', border: `1px solid ${C.rule}`,
              color: C.ink, padding: '14px 16px',
              borderRadius: 14, cursor: 'pointer', textAlign: 'left',
              display: 'flex', flexDirection: 'column', gap: 3,
            }}>
              <span style={{
                fontFamily: YEAR_SANS, fontSize: 14, fontWeight: 600, color: C.ink,
              }}>Reset all data</span>
              <span style={{
                fontFamily: YEAR_SANS, fontSize: 12, color: C.sub, fontWeight: 400,
              }}>Removes all goals and pockets. Cannot be undone.</span>
            </button>
          ) : (
            <div style={{
              border: `1px solid ${C.rule}`, borderRadius: 14, padding: 14,
              display: 'flex', flexDirection: 'column', gap: 12,
              background: C.surface,
            }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
                <span style={{ fontFamily: YEAR_SANS, fontSize: 14, fontWeight: 600,
                  color: C.ink }}>Reset everything?</span>
                <span style={{ fontFamily: YEAR_SANS, fontSize: 12, color: C.sub }}>
                  All goals, pockets, and progress will be cleared.
                </span>
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button onClick={() => setConfirmReset(false)} style={{
                  flex: 1, background: 'transparent', border: `1px solid ${C.rule}`,
                  color: C.ink, padding: '10px 12px', borderRadius: 999,
                  fontFamily: YEAR_MONO, fontSize: 10, letterSpacing: 1.4,
                  textTransform: 'uppercase', fontWeight: 600, cursor: 'pointer',
                }}>Cancel</button>
                <button onClick={onReset} style={{
                  flex: 1,
                  background: isDark ? '#c54545' : '#b91c1c',
                  border: 'none', color: '#fff',
                  padding: '10px 12px', borderRadius: 999,
                  fontFamily: YEAR_MONO, fontSize: 10, letterSpacing: 1.4,
                  textTransform: 'uppercase', fontWeight: 600, cursor: 'pointer',
                }}>Reset</button>
              </div>
            </div>
          )}
        </div>
      </div>
    </>
  );
}

// ─── ANIMATIONS ──────────────────────────────────────────────────────
if (typeof document !== 'undefined' && !document.getElementById('year-anim')) {
  const s = document.createElement('style');
  s.id = 'year-anim';
  s.textContent = `
    @keyframes yearSheetUp {
      from { transform: translateY(100%); }
      to   { transform: translateY(0); }
    }
    @keyframes yearBackdropIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }
    @keyframes yearWiggle {
      0%   { transform: rotate(-0.5deg); }
      100% { transform: rotate(0.5deg); }
    }
  `;
  document.head.appendChild(s);
}

window.AtelierYear = AtelierYear;

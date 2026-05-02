// Atelier Grid — pockets home + category detail.
// Tap a pocket → detail. Long-press home pockets → manage mode.
// Detail has the goals listed wall-style, with add/remove + niceties:
//   - inline detail editing
//   - move-to-other-pocket
//   - star a goal as the "north star" of the pocket
//   - small sparkline of last 7 days check-ins (placeholder data)

const GRID_PALETTES = {
  light: {
    bg: '#ffffff', ink: '#0a0a0a', sub: '#525252', mute: '#a3a3a3',
    rule: '#ededed', ruleHi: '#0a0a0a', accent: '#0a0a0a',
    chip: '#fafafa', pocket: '#ffffff',
    starBg: '#ededed', starBorder: '#dcdcdc', starInk: '#0a0a0a',
    danger: '#c44a1c', dangerBg: '#fef2ec',
  },
  dark: {
    bg: '#0a0a0a', ink: '#fafafa', sub: '#a3a3a3', mute: '#525252',
    rule: '#1f1f1f', ruleHi: '#fafafa', accent: '#9bf00b',
    chip: '#141414', pocket: '#0a0a0a',
    starBg: '#262626', starBorder: '#333333', starInk: '#fafafa',
    danger: '#ff6b3a', dangerBg: '#1f0f0a',
  },
};

// addedDay = day-of-month when the goal was first added (drives "X days here")
const INITIAL_GOALS = [
  { id: 1,  area: 'Work',  title: 'Ship side project v0.1', detail: 'Quiet launch, month-end', star: true,  addedDay: 1 },
  { id: 2,  area: 'Work',  title: '€500 to brokerage',      detail: 'Auto-transfer set',       star: false, addedDay: 3 },
  { id: 3,  area: 'Body',  title: 'Sub-25 5K',              detail: 'PB 26:14',                star: true,  addedDay: 1 },
  { id: 4,  area: 'Body',  title: 'Strength 3×/wk',         detail: 'Push · pull · legs',      star: false, addedDay: 1 },
  { id: 5,  area: 'Body',  title: 'Long run Sat',           detail: 'Build to 12 km',          star: false, addedDay: 6 },
  { id: 6,  area: 'Mind',  title: 'Beginning of Infinity',  detail: 'Deutsch · finish',        star: true,  addedDay: 2 },
  { id: 7,  area: 'Mind',  title: 'Severance S2',           detail: 'Tue evenings',            star: false, addedDay: 4 },
  { id: 8,  area: 'Skill', title: 'Rust ownership',         detail: 'In Action ch. 4–7',       star: true,  addedDay: 1 },
  { id: 9,  area: 'Skill', title: 'Italian A2',             detail: 'Pimsleur 14–20',          star: false, addedDay: 5 },
  { id:10,  area: 'Skill', title: 'Tonal harmony',          detail: '15m at piano',            star: false, addedDay: 8 },
  { id:11,  area: 'Daily', title: 'Read 20m before bed',    detail: 'No exceptions',           star: true,  addedDay: 1 },
  { id:12,  area: 'Daily', title: 'No phone before 9am',    detail: 'Weekdays',                star: false, addedDay: 1 },
  { id:13,  area: 'Play',  title: 'Silksong',               detail: 'Main story',              star: false, addedDay: 7 },
  { id:14,  area: 'Life',  title: 'Renew passport',         detail: 'Before 20th',             star: true,  addedDay: 2 },
  { id:15,  area: 'Life',  title: 'Lisbon trip',            detail: 'Book flights',            star: false, addedDay: 9 },
];

function daysHere(addedDay) {
  const d = Math.max(0, dayOfMonth - addedDay);
  if (d === 0) return 'today';
  if (d === 1) return '1 day';
  return `${d} days`;
}

const INITIAL_AREAS = ['Work', 'Body', 'Mind', 'Skill', 'Daily', 'Play', 'Life', 'Open'];

function AtelierGrid({ initialRoute }) {
  const [theme, setTheme] = React.useState('light');
  const [goals, setGoals] = React.useState(INITIAL_GOALS);
  const [areas, setAreas] = React.useState(INITIAL_AREAS);
  const [route, setRoute] = React.useState(initialRoute || { name: 'home' });
  const [manage, setManage] = React.useState(false);
  const [settingsOpen, setSettingsOpen] = React.useState(false);
  const [fontScale, setFontScale] = React.useState('M'); // S | M | L

  const C = GRID_PALETTES[theme];
  const isDark = theme === 'dark';

  const display = '"Fraunces", "Instrument Serif", Georgia, serif';
  const sans = '"Inter", ui-sans-serif, system-ui, sans-serif';
  const mono = '"JetBrains Mono", ui-monospace, monospace';

  // mutations
  const addGoal = (area, title) => {
    if (!title.trim()) return;
    setGoals((gs) => [
      ...gs,
      { id: Date.now(), area, title: title.trim(), detail: '',
        star: false, addedDay: dayOfMonth },
    ]);
  };
  const removeGoal = (id) => setGoals((gs) => gs.filter((g) => g.id !== id));
  const updateGoal = (id, patch) =>
    setGoals((gs) => gs.map((g) => g.id === id ? { ...g, ...patch } : g));
  const toggleStar = (id) =>
    setGoals((gs) => gs.map((g) =>
      g.area === gs.find((x) => x.id === id).area
        ? { ...g, star: g.id === id ? !g.star : false } // one star per pocket
        : g
    ));
  const addArea = (name) => {
    const n = name.trim();
    if (!n || areas.includes(n)) return;
    setAreas((a) => [...a.filter((x) => x !== 'Open'), n, 'Open']);
  };
  const removeArea = (name) => {
    setAreas((a) => a.filter((x) => x !== name));
    setGoals((gs) => gs.filter((g) => g.area !== name));
  };

  const resetAll = () => {
    // Reset in-memory state
    setGoals(INITIAL_GOALS);
    setAreas(INITIAL_AREAS);
    setTheme('light');
    setFontScale('M');
    setManage(false);
    setRoute({ name: 'home' });
    setSettingsOpen(false);
    // Clear known persistence keys used elsewhere in the prototype
    try {
      localStorage.removeItem('atelier:yearbanner:expanded:v1');
      localStorage.removeItem('atelier:yearbanner:removed:v1');
    } catch (e) {}
  };

  const ctx = {
    C, isDark, display, mono, sans, theme, setTheme,
    goals, areas, addGoal, removeGoal, updateGoal, toggleStar, addArea, removeArea,
    route, setRoute, manage, setManage,
    settingsOpen, setSettingsOpen,
    fontScale, setFontScale,
    resetAll,
  };

  // Map font scale to a root font-size — children using rem-ish px values
  // remain px-fixed, but inputs we built with a few key sizes use scale.
  const fontScalePct = fontScale === 'S' ? 0.92 : fontScale === 'L' ? 1.10 : 1;

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: sans, transition: 'background .25s, color .25s',
      position: 'relative',
      fontSize: `${16 * fontScalePct}px`,
    }}>
      <StatusBar C={C} />
      {route.name === 'home'
        ? <HomeView {...ctx} />
        : <DetailView {...ctx} area={route.area} />}
      {settingsOpen && (
        <SettingsSheet
          C={C} display={display} mono={mono} sans={sans}
          theme={theme} setTheme={setTheme}
          fontScale={fontScale} setFontScale={setFontScale}
          onReset={resetAll}
          onClose={() => setSettingsOpen(false)}
        />
      )}
    </div>
  );
}

function StatusBar({ C }) {
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

function TopBar({ C, display, mono, isDark, setTheme,
                  back, title, rightExtra, hideThemeToggle, hideTickStrip,
                  focusBtn }) {
  return (
    <div style={{ padding: '14px 22px 16px', flexShrink: 0 }}>
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        marginBottom: 14,
      }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
          {back && (
            <button onClick={back} style={{
              background: 'transparent', border: 'none', color: C.sub,
              cursor: 'pointer', padding: 0, marginRight: 4,
              fontFamily: mono, fontSize: 13, lineHeight: 1,
            }}>←</button>
          )}
          <span style={{
            fontFamily: display, fontSize: 24, fontStyle: 'italic',
            fontWeight: 400, letterSpacing: -0.5, color: C.ink,
          }}>{title || 'May'}</span>
          {!title && (
            <span style={{
              fontFamily: mono, fontSize: 10, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>2026</span>
          )}
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          {rightExtra}
          {!title && (
            <span style={{
              fontFamily: mono, fontSize: 10, color: C.sub, letterSpacing: 1.4,
            }}>
              <span style={{ color: C.ink, fontWeight: 600 }}>{daysLeft}</span>
              <span style={{ color: C.mute }}> DAYS LEFT</span>
            </span>
          )}
          {!hideThemeToggle && (
            <button
              onClick={() => setTheme(isDark ? 'light' : 'dark')}
              aria-label="toggle theme"
              style={{
                background: 'transparent', border: `1px solid ${C.rule}`,
                color: C.sub, width: 26, height: 26, borderRadius: 999,
                fontSize: 11, cursor: 'pointer', display: 'flex',
                alignItems: 'center', justifyContent: 'center', padding: 0,
              }}>
              {isDark ? '☼' : '☾'}
            </button>
          )}
          {focusBtn}
        </div>
      </div>

      {!title && !hideTickStrip && <TickStrip C={C} />}
    </div>
  );
}

function TickStrip({ C }) {
  return (
    <div style={{ position: 'relative', height: 14 }}>
      <div style={{
        position: 'absolute', left: 0, right: 0, top: 6,
        height: 1, background: C.rule,
      }}/>
      {Array.from({ length: MONTH.daysInMonth }).map((_, i) => {
        const day = i + 1;
        const isToday = day === dayOfMonth;
        const isMajor = day % 5 === 0 || day === 1 || day === MONTH.daysInMonth;
        return (
          <div key={i} style={{
            position: 'absolute',
            left: `${(i / (MONTH.daysInMonth - 1)) * 100}%`,
            top: 6, transform: 'translate(-50%, 0)',
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
function HomeView(ctx) {
  const { C, display, mono, sans, isDark, setTheme, goals, areas,
          setRoute, manage, setManage, removeArea, addArea,
          setSettingsOpen } = ctx;
  const [adding, setAdding] = React.useState(false);
  const [newName, setNewName] = React.useState('');
  const [focus, setFocus] = React.useState(false);

  const pockets = areas.map((area) => ({
    area, items: goals.filter((g) => g.area === area),
  }));

  const lpRef = React.useRef(null);
  const startLP = () => {
    clearTimeout(lpRef.current);
    lpRef.current = setTimeout(() => setManage(true), 450);
  };
  const cancelLP = () => clearTimeout(lpRef.current);

  return (
    <>
      <TopBar
        C={C} display={display} mono={mono}
        isDark={isDark} setTheme={setTheme}
        hideThemeToggle
        rightExtra={
          <>
            {manage && (
              <button onClick={() => setManage(false)} style={{
                background: C.ink, color: C.bg, border: 'none',
                padding: '4px 10px', borderRadius: 999,
                fontFamily: mono, fontSize: 9.5, letterSpacing: 1.4,
                textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
              }}>Done</button>
            )}
            {!manage && (
              <button onClick={() => setSettingsOpen(true)}
                aria-label="settings"
                style={{
                  background: 'transparent', border: `1px solid ${C.rule}`,
                  color: C.sub, width: 26, height: 26, borderRadius: 999,
                  fontSize: 13, cursor: 'pointer', display: 'flex',
                  alignItems: 'center', justifyContent: 'center', padding: 0,
                  lineHeight: 1,
                }}>⚙</button>
            )}
          </>
        }
      />

      <div style={{ flex: 1, overflow: 'auto', padding: '4px 22px 20px' }}
        onMouseDown={startLP} onMouseUp={cancelLP} onMouseLeave={cancelLP}
        onTouchStart={startLP} onTouchEnd={cancelLP}>
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8,
        }}>
          {pockets.map((p) => (
            <Pocket key={p.area} p={p} C={C}
              display={display} mono={mono} sans={sans}
              onOpen={() => !manage && setRoute({ name: 'detail', area: p.area })}
              manage={manage}
              onRemove={() => removeArea(p.area)} />
          ))}
          {manage && (
            <AddPocket C={C} display={display} mono={mono}
              adding={adding} setAdding={setAdding}
              newName={newName} setNewName={setNewName}
              onAdd={() => { addArea(newName); setNewName(''); setAdding(false); }} />
          )}
        </div>

        {!manage && (
          <div style={{
            marginTop: 14, padding: '8px 6px',
            fontFamily: mono, fontSize: 9, color: C.mute,
            letterSpacing: 1.4, textAlign: 'center',
          }}>HOLD ANY POCKET TO MANAGE</div>
        )}
      </div>

      {focus && (
        <FocusOverlay
          C={C} display={display} mono={mono} sans={sans}
          goals={goals} areas={areas}
          onClose={() => setFocus(false)}
          onOpenPocket={(area) => { setFocus(false); setRoute({ name: 'detail', area }); }}
        />
      )}
    </>
  );
}

function FocusOverlay({ C, display, mono, sans, goals, areas, onClose, onOpenPocket }) {
  const grouped = areas
    .map((area) => ({ area, items: goals.filter((g) => g.area === area && g.star) }))
    .filter((g) => g.items.length > 0);
  const total = grouped.reduce((s, g) => s + g.items.length, 0);

  return (
    <div style={{
      position: 'absolute', inset: 0, background: C.bg,
      display: 'flex', flexDirection: 'column', zIndex: 10,
      animation: 'fadein .2s ease-out',
    }}>
      <div style={{
        height: 36, padding: '0 22px', display: 'flex',
        alignItems: 'center', justifyContent: 'space-between',
        fontSize: 13, fontWeight: 600, color: C.ink, flexShrink: 0,
      }}>
        <span>9:41</span>
        <span style={{ fontSize: 11, opacity: 0.7 }}>●●●● · 86%</span>
      </div>

      <div style={{ padding: '14px 22px 16px', flexShrink: 0,
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
      }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
          <span style={{
            fontFamily: display, fontSize: 24, fontStyle: 'italic',
            fontWeight: 400, letterSpacing: -0.5, color: C.ink,
          }}>Focus</span>
          <span style={{
            fontFamily: mono, fontSize: 10, color: C.mute,
            letterSpacing: 1.4, textTransform: 'uppercase',
          }}>{total} starred</span>
        </div>
        <button onClick={onClose} aria-label="close" style={{
          background: 'transparent', border: `1px solid ${C.rule}`,
          color: C.sub, width: 26, height: 26, borderRadius: 999,
          fontSize: 12, cursor: 'pointer', display: 'flex',
          alignItems: 'center', justifyContent: 'center', padding: 0,
          lineHeight: 1,
        }}>×</button>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '0 22px 24px' }}>
        {grouped.map((g, gi) => (
          <div key={g.area} style={{
            paddingTop: gi === 0 ? 0 : 18, paddingBottom: 14,
            borderTop: gi === 0 ? 'none' : `1px solid ${C.rule}`,
          }}>
            <button onClick={() => onOpenPocket(g.area)} style={{
              background: 'transparent', border: 'none', cursor: 'pointer',
              padding: '0 0 10px', display: 'flex', alignItems: 'baseline',
              justifyContent: 'space-between', width: '100%',
            }}>
              <span style={{
                fontFamily: mono, fontSize: 9.5, letterSpacing: 2.4,
                textTransform: 'uppercase', color: C.sub, fontWeight: 600,
              }}>{g.area}</span>
              <span style={{
                fontFamily: mono, fontSize: 9, color: C.mute,
                letterSpacing: 1,
              }}>open ↗</span>
            </button>
            {g.items.map((it) => (
              <div key={it.id} style={{
                background: C.starBg,
                border: `1px solid ${C.starBorder}`,
                borderRadius: 10,
                padding: '12px 14px',
                marginBottom: 6,
              }}>
                <div style={{
                  fontFamily: display, fontSize: 17, fontWeight: 400,
                  letterSpacing: -0.3, lineHeight: 1.2, color: C.starInk,
                }}>{it.title}</div>
                {it.detail && (
                  <div style={{
                    fontFamily: sans, fontSize: 12, color: C.sub,
                    marginTop: 4, lineHeight: 1.45,
                  }}>{it.detail}</div>
                )}
              </div>
            ))}
          </div>
        ))}
        {total === 0 && (
          <div style={{
            padding: '60px 0', textAlign: 'center',
            fontFamily: mono, fontSize: 10, color: C.mute,
            letterSpacing: 1.4, textTransform: 'uppercase',
          }}>No starred goals yet</div>
        )}
      </div>
    </div>
  );
}

function Pocket({ p, C, display, mono, sans, onOpen, manage, onRemove }) {
  const empty = p.items.length === 0;
  const star = p.items.find((x) => x.star);

  return (
    <div onClick={onOpen} style={{
      background: C.pocket,
      border: `1px solid ${C.rule}`,
      borderRadius: 14,
      padding: '10px 10px 10px',
      display: 'flex', flexDirection: 'column', gap: 6,
      minHeight: 110, minWidth: 0, cursor: manage ? 'default' : 'pointer',
      animation: manage ? 'wiggle 0.4s ease-in-out infinite alternate' : 'none',
      position: 'relative',
    }}>
      {manage && p.area !== 'Open' && (
        <button onClick={(e) => { e.stopPropagation(); onRemove(); }}
          style={{
            position: 'absolute', top: -6, left: -6, zIndex: 2,
            width: 20, height: 20, borderRadius: 999,
            background: C.danger, color: '#fff', border: 'none',
            fontSize: 14, lineHeight: 1, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            padding: 0, fontWeight: 600,
          }}>−</button>
      )}

      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        padding: '0 4px 4px',
      }}>
        <span style={{
          fontFamily: mono, fontSize: 9, letterSpacing: 1.8,
          textTransform: 'uppercase', color: C.sub, fontWeight: 600,
        }}>{p.area}</span>
        <span style={{
          fontFamily: mono, fontSize: 9, color: C.mute, letterSpacing: 1,
        }}>{empty ? '—' : String(p.items.length).padStart(2, '0')}</span>
      </div>

      {empty ? (
        <div style={{
          flex: 1, minHeight: 64,
          border: `1px dashed ${C.rule}`,
          borderRadius: 10,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: mono, fontSize: 9.5, color: C.mute,
          letterSpacing: 1.2, textTransform: 'uppercase',
        }}>{p.area === 'Open' ? 'Open · add' : 'Empty'}</div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
          {p.items.slice(0, 4).map((g) => (
            <div key={g.id} style={{
              background: g.star ? C.starBg : C.chip,
              border: `1px solid ${g.star ? C.starBorder : C.rule}`,
              borderRadius: 8,
              padding: '8px 10px',
              fontFamily: display, fontSize: 12.5, fontWeight: 400,
              letterSpacing: -0.2, lineHeight: 1.25,
              color: g.star ? C.starInk : C.ink,
              display: 'flex', alignItems: 'center', gap: 6,
              minWidth: 0,
            }}>
              {g.star && <span style={{ color: C.starInk, fontSize: 9, lineHeight: 1, flexShrink: 0 }}>★</span>}
              <span style={{
                overflow: 'hidden', textOverflow: 'ellipsis',
                whiteSpace: 'nowrap', minWidth: 0,
              }}>{g.title}</span>
            </div>
          ))}
          {p.items.length > 4 && (
            <div style={{
              fontFamily: mono, fontSize: 9, color: C.mute,
              letterSpacing: 1, padding: '2px 4px',
            }}>+{p.items.length - 4} more</div>
          )}
        </div>
      )}
    </div>
  );
}

function AddPocket({ C, display, mono, adding, setAdding, newName, setNewName, onAdd }) {
  if (!adding) {
    return (
      <button onClick={() => setAdding(true)} style={{
        background: 'transparent',
        border: `1px dashed ${C.rule}`, borderRadius: 14,
        minHeight: 110, cursor: 'pointer',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontFamily: mono, fontSize: 10, color: C.sub,
        letterSpacing: 1.4, textTransform: 'uppercase',
      }}>+ Add pocket</button>
    );
  }
  return (
    <div style={{
      background: C.pocket, border: `1px solid ${C.ruleHi}`, borderRadius: 14,
      padding: 10, minHeight: 110,
      display: 'flex', flexDirection: 'column', gap: 8,
    }}>
      <input autoFocus value={newName}
        onChange={(e) => setNewName(e.target.value)}
        onKeyDown={(e) => e.key === 'Enter' && onAdd()}
        placeholder="Name…"
        style={{
          background: 'transparent', border: 'none',
          fontFamily: display, fontSize: 14, color: C.ink, outline: 'none',
        }}/>
      <div style={{ display: 'flex', gap: 6, marginTop: 'auto' }}>
        <button onClick={onAdd} style={{
          flex: 1, background: C.ink, color: C.bg, border: 'none',
          padding: '6px', borderRadius: 8,
          fontFamily: mono, fontSize: 9.5, letterSpacing: 1.4,
          textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
        }}>Add</button>
      </div>
    </div>
  );
}

// ─── DETAIL ──────────────────────────────────────────────────────────
function DetailView(ctx) {
  const { C, display, mono, sans, isDark, setTheme, goals, area,
          setRoute, addGoal, removeGoal, updateGoal, toggleStar } = ctx;
  const items = goals.filter((g) => g.area === area);
  const [adding, setAdding] = React.useState(false);
  const [newTitle, setNewTitle] = React.useState('');

  return (
    <>
      <TopBar
        C={C} display={display} mono={mono}
        isDark={isDark} setTheme={setTheme}
        back={() => setRoute({ name: 'home' })}
        title={area}
        hideThemeToggle
        hideTickStrip
      />

      {/* Pocket meta strip */}
      <div style={{
        padding: '0 22px 14px', display: 'flex',
        justifyContent: 'space-between', alignItems: 'baseline', gap: 12,
      }}>
        <div style={{
          fontFamily: sans, fontSize: 12, color: C.sub, lineHeight: 1.5,
        }}>
          <span style={{ color: C.ink, fontWeight: 600 }}>{items.length}</span>
          <span style={{ color: C.mute }}> {items.length === 1 ? 'goal' : 'goals'} · since day </span>
          <span style={{ color: C.ink, fontWeight: 600 }}>{Math.min(...items.map((g) => g.addedDay), dayOfMonth)}</span>
        </div>
      </div>

      <div style={{
        margin: '0 22px', borderTop: `1px solid ${C.rule}`,
      }}/>

      <div style={{ flex: 1, overflow: 'auto', padding: '4px 22px 80px' }}>
        {items.map((g, i) => (
          <DetailGoal key={g.id} g={g} C={C} display={display} mono={mono} sans={sans}
            isLast={i === items.length - 1}
            onUpdate={(patch) => updateGoal(g.id, patch)}
            onRemove={() => removeGoal(g.id)}
            onStar={() => toggleStar(g.id)} />
        ))}

        {items.length === 0 && (
          <div style={{
            padding: '36px 0', textAlign: 'center',
            fontFamily: mono, fontSize: 10, color: C.mute,
            letterSpacing: 1.4, textTransform: 'uppercase',
          }}>Pocket is empty</div>
        )}
      </div>

      {/* Add bar — pinned bottom */}
      <div style={{
        position: 'absolute', left: 14, right: 14, bottom: 14,
        background: C.pocket, border: `1px solid ${C.rule}`,
        borderRadius: 14, padding: '8px 10px',
        display: 'flex', alignItems: 'center', gap: 8,
        boxShadow: isDark ? '0 8px 24px rgba(0,0,0,0.5)'
                          : '0 8px 24px rgba(0,0,0,0.06)',
      }}>
        {!adding ? (
          <button onClick={() => setAdding(true)} style={{
            flex: 1, background: 'transparent', border: 'none', cursor: 'pointer',
            fontFamily: mono, fontSize: 10, letterSpacing: 1.4,
            textTransform: 'uppercase', color: C.sub, fontWeight: 600,
            padding: '8px 6px', textAlign: 'left',
          }}>+ Add to {area}</button>
        ) : (
          <>
            <input autoFocus value={newTitle}
              onChange={(e) => setNewTitle(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') {
                  addGoal(area, newTitle); setNewTitle(''); setAdding(false);
                } else if (e.key === 'Escape') {
                  setAdding(false); setNewTitle('');
                }
              }}
              placeholder="New goal title…"
              style={{
                flex: 1, background: 'transparent', border: 'none',
                fontFamily: display, fontSize: 15, color: C.ink, outline: 'none',
                padding: '6px 4px',
              }}/>
            <button onClick={() => {
              addGoal(area, newTitle); setNewTitle(''); setAdding(false);
            }} style={{
              background: C.ink, color: C.bg, border: 'none',
              padding: '6px 12px', borderRadius: 8,
              fontFamily: mono, fontSize: 10, letterSpacing: 1.4,
              textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
            }}>Add</button>
          </>
        )}
      </div>
    </>
  );
}

function DetailGoal({ g, C, display, mono, sans, isLast, onUpdate, onRemove, onStar }) {
  const [open, setOpen] = React.useState(false);

  return (
    <div style={{
      padding: '16px 14px',
      margin: '0 -14px',
      borderRadius: g.star ? 12 : 0,
      background: g.star ? C.starBg : 'transparent',
      borderBottom: isLast ? 'none' : `1px solid ${g.star ? 'transparent' : C.rule}`,
    }}>
      <div style={{
        display: 'flex', alignItems: 'baseline', gap: 10,
      }}>
        <button onClick={onStar} style={{
          background: 'transparent', border: 'none', cursor: 'pointer',
          color: g.star ? C.starInk : C.mute, fontSize: 12,
          padding: 2, lineHeight: 1, marginTop: 6,
        }}>{g.star ? '★' : '☆'}</button>

        <div style={{ flex: 1, minWidth: 0 }}
          onClick={() => setOpen(!open)}>
          <div style={{
            fontFamily: display, fontSize: 17, fontWeight: 400,
            letterSpacing: -0.3, lineHeight: 1.2, color: C.ink,
          }}>{g.title}</div>
          {g.detail && (
            <div style={{
              fontFamily: sans, fontSize: 12, color: C.sub,
              marginTop: 4, lineHeight: 1.45,
            }}>{g.detail}</div>
          )}
        </div>

        <div style={{
          fontFamily: mono, fontSize: 9, color: C.mute,
          letterSpacing: 1, textTransform: 'uppercase',
          marginTop: 8, whiteSpace: 'nowrap',
        }}>{daysHere(g.addedDay)}</div>
      </div>

      {open && (
        <div style={{
          marginTop: 10, paddingTop: 10, paddingLeft: 22,
          borderTop: `1px dashed ${C.rule}`,
          display: 'flex', gap: 8, alignItems: 'center',
        }}>
          <input value={g.detail}
            onChange={(e) => onUpdate({ detail: e.target.value })}
            placeholder="Add a note…"
            style={{
              flex: 1, background: 'transparent',
              border: `1px solid ${C.rule}`, borderRadius: 6,
              padding: '6px 8px', fontFamily: sans, fontSize: 12,
              color: C.ink, outline: 'none',
            }}/>
          <button onClick={onRemove} style={{
            background: 'transparent', border: `1px solid ${C.rule}`,
            color: C.danger, padding: '6px 10px', borderRadius: 6,
            fontFamily: mono, fontSize: 9.5, letterSpacing: 1.4,
            textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
          }}>Remove</button>
        </div>
      )}
    </div>
  );
}



// inject animation once
if (typeof document !== 'undefined' && !document.getElementById('grid-anim')) {
  const s = document.createElement('style');
  s.id = 'grid-anim';
  s.textContent = `
    @keyframes wiggle {
      0% { transform: rotate(-0.4deg); }
      100% { transform: rotate(0.4deg); }
    }
    @keyframes fadein {
      from { opacity: 0; transform: translateY(4px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes sheetUp {
      from { transform: translateY(100%); }
      to { transform: translateY(0); }
    }
    @keyframes backdropIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
  `;
  document.head.appendChild(s);
}

// ─── SETTINGS SHEET ──────────────────────────────────────────────────
function SettingsSheet({ C, display, mono, sans, theme, setTheme,
                          fontScale, setFontScale, onReset, onClose }) {
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
              fontFamily: mono, fontSize: 10, letterSpacing: 1.4,
              textTransform: 'uppercase', fontWeight: 600,
              cursor: 'pointer', transition: 'background .15s, color .15s',
            }}>{o.label}</button>
        );
      })}
    </div>
  );

  return (
    <>
      {/* backdrop */}
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0,
        background: 'rgba(0,0,0,0.35)',
        zIndex: 50, animation: 'backdropIn .2s ease-out',
      }}/>
      {/* sheet */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: C.bg, color: C.ink, zIndex: 51,
        borderTopLeftRadius: 22, borderTopRightRadius: 22,
        boxShadow: '0 -8px 30px rgba(0,0,0,0.18)',
        animation: 'sheetUp .25s cubic-bezier(.2,.8,.2,1)',
        padding: '12px 22px 28px', display: 'flex', flexDirection: 'column',
        gap: 22,
      }}>
        {/* drag handle */}
        <div style={{
          width: 38, height: 4, background: C.rule, borderRadius: 999,
          alignSelf: 'center',
        }}/>

        {/* header */}
        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          marginTop: -6,
        }}>
          <span style={{
            fontFamily: display, fontSize: 24, fontStyle: 'italic',
            fontWeight: 400, letterSpacing: -0.5, color: C.ink,
          }}>Settings</span>
          <button onClick={onClose} style={{
            background: 'transparent', border: 'none', color: C.sub,
            fontFamily: mono, fontSize: 10, letterSpacing: 1.4,
            textTransform: 'uppercase', cursor: 'pointer', padding: 0,
          }}>Close</button>
        </div>

        {/* THEME */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <span style={{
            fontFamily: mono, fontSize: 9.5, color: C.mute,
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

        {/* FONT SIZE */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <span style={{
            fontFamily: mono, fontSize: 9.5, color: C.mute,
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

        {/* divider */}
        <div style={{ height: 1, background: C.rule, margin: '2px 0' }}/>

        {/* RESET */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {!confirmReset ? (
            <button onClick={() => setConfirmReset(true)} style={{
              background: 'transparent',
              border: `1px solid ${C.rule}`,
              color: C.ink, padding: '14px 16px',
              borderRadius: 14, cursor: 'pointer', textAlign: 'left',
              display: 'flex', flexDirection: 'column', gap: 3,
            }}>
              <span style={{
                fontFamily: sans, fontSize: 14, fontWeight: 600, color: C.ink,
              }}>Reset all data</span>
              <span style={{
                fontFamily: sans, fontSize: 12, color: C.sub, fontWeight: 400,
              }}>Removes all goals and pockets. Cannot be undone.</span>
            </button>
          ) : (
            <div style={{
              border: `1px solid ${C.rule}`, borderRadius: 14, padding: 14,
              display: 'flex', flexDirection: 'column', gap: 12,
              background: C.surface,
            }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
                <span style={{ fontFamily: sans, fontSize: 14, fontWeight: 600,
                  color: C.ink }}>Reset everything?</span>
                <span style={{ fontFamily: sans, fontSize: 12, color: C.sub }}>
                  All goals, pockets, and progress will be cleared.
                </span>
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button onClick={() => setConfirmReset(false)} style={{
                  flex: 1, background: 'transparent', border: `1px solid ${C.rule}`,
                  color: C.ink, padding: '10px 12px', borderRadius: 999,
                  fontFamily: mono, fontSize: 10, letterSpacing: 1.4,
                  textTransform: 'uppercase', fontWeight: 600, cursor: 'pointer',
                }}>Cancel</button>
                <button onClick={onReset} style={{
                  flex: 1,
                  background: isDark ? '#c54545' : '#b91c1c',
                  border: 'none', color: '#fff',
                  padding: '10px 12px', borderRadius: 999,
                  fontFamily: mono, fontSize: 10, letterSpacing: 1.4,
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

window.AtelierGrid = AtelierGrid;

// Variant pre-routed to a specific pocket for the canvas preview
function AtelierGridStartingAt({ area }) {
  // Mount AtelierGrid, then immediately programmatically route via a
  // wrapper that overrides the initial route prop.
  return <AtelierGrid initialRoute={{ name: 'detail', area }} />;
}
window.AtelierGridStartingAt = AtelierGridStartingAt;

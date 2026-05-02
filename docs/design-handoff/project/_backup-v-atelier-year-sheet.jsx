// Year-view variants — three explorations of how to surface year goals
// alongside the month pockets. All share the same palette/typography as
// AtelierGrid; each variant is a self-contained phone screen.
//
// V1 — YearBand: horizontal strip of year goals above the month grid.
// V2 — YearSheet: month grid by default, swipe/tap up reveals a year sheet.
// V3 — YearInPocket: each pocket's year goal sits as a quiet header line.

const YEAR_PALETTES = {
  light: {
    bg: '#ffffff', ink: '#0a0a0a', sub: '#525252', mute: '#a3a3a3',
    rule: '#ededed', ruleHi: '#0a0a0a', accent: '#0a0a0a',
    chip: '#fafafa', pocket: '#ffffff',
    starBg: '#ededed', starBorder: '#dcdcdc', starInk: '#0a0a0a',
    yearBg: '#f5f5f2', yearInk: '#0a0a0a',
  },
  dark: {
    bg: '#0a0a0a', ink: '#fafafa', sub: '#a3a3a3', mute: '#525252',
    rule: '#1f1f1f', ruleHi: '#fafafa', accent: '#9bf00b',
    chip: '#141414', pocket: '#0a0a0a',
    starBg: '#262626', starBorder: '#333333', starInk: '#fafafa',
    yearBg: '#141414', yearInk: '#fafafa',
  },
};

const YEAR_DISPLAY = '"Fraunces", "Instrument Serif", Georgia, serif';
const YEAR_SANS = '"Inter", ui-sans-serif, system-ui, sans-serif';
const YEAR_MONO = '"JetBrains Mono", ui-monospace, monospace';

// Shared status bar (matches AtelierGrid)
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

// Shared month title row
function YMonthHead({ C, right }) {
  return (
    <div style={{
      padding: '14px 22px 0', display: 'flex',
      justifyContent: 'space-between', alignItems: 'baseline', flexShrink: 0,
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
        <span style={{
          fontFamily: YEAR_MONO, fontSize: 10, color: C.sub, letterSpacing: 1.4,
        }}>
          <span style={{ color: C.ink, fontWeight: 600 }}>{daysLeft}</span>
          <span style={{ color: C.mute }}> DAYS LEFT</span>
        </span>
        {right}
      </div>
    </div>
  );
}

// Shared month-pocket grid (compact, like AtelierGrid home)
function YPocketGrid({ C, areas, goals, onOpen, header, footer, scrollPad = '12px 22px 20px' }) {
  const pockets = areas.map((area) => ({
    area, items: goals.filter((g) => g.area === area),
  }));
  return (
    <div style={{ flex: 1, overflow: 'auto', padding: scrollPad }}>
      {header}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
        {pockets.map((p) => (
          <YPocket key={p.area} p={p} C={C} onOpen={() => onOpen && onOpen(p.area)} />
        ))}
      </div>
      {footer}
    </div>
  );
}

function YPocket({ p, C, onOpen, yearLine }) {
  const empty = p.items.length === 0;
  return (
    <div onClick={onOpen} style={{
      background: C.pocket, border: `1px solid ${C.rule}`, borderRadius: 14,
      padding: '10px 10px', display: 'flex', flexDirection: 'column', gap: 6,
      minHeight: 110, minWidth: 0, cursor: onOpen ? 'pointer' : 'default',
    }}>
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

      {yearLine}

      {empty ? (
        <div style={{
          flex: 1, minHeight: 64,
          border: `1px dashed ${C.rule}`, borderRadius: 10,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: YEAR_MONO, fontSize: 9.5, color: C.mute,
          letterSpacing: 1.2, textTransform: 'uppercase',
        }}>{p.area === 'Open' ? 'Open · add' : 'Empty'}</div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
          {p.items.slice(0, 4).map((g) => (
            <div key={g.id} style={{
              background: g.star ? C.starBg : C.chip,
              border: `1px solid ${g.star ? C.starBorder : C.rule}`,
              borderRadius: 8, padding: '8px 10px',
              fontFamily: YEAR_DISPLAY, fontSize: 12.5, fontWeight: 400,
              letterSpacing: -0.2, lineHeight: 1.25,
              color: g.star ? C.starInk : C.ink,
              display: 'flex', alignItems: 'center', gap: 6, minWidth: 0,
            }}>
              {g.star && <span style={{ color: C.starInk, fontSize: 9, flexShrink: 0 }}>★</span>}
              <span style={{
                overflow: 'hidden', textOverflow: 'ellipsis',
                whiteSpace: 'nowrap', minWidth: 0,
              }}>{g.title}</span>
            </div>
          ))}
          {p.items.length > 4 && (
            <div style={{
              fontFamily: YEAR_MONO, fontSize: 9, color: C.mute,
              letterSpacing: 1, padding: '2px 4px',
            }}>+{p.items.length - 4} more</div>
          )}
        </div>
      )}
    </div>
  );
}

// Default values shared across variants
const Y_AREAS = ['Work', 'Body', 'Mind', 'Skill', 'Daily', 'Play', 'Life', 'Open'];
const Y_GOALS_BASE = (window.INITIAL_GOALS_FOR_YEAR || null);

// The base month goals: replicate from AtelierGrid scope.
// (AtelierGrid's INITIAL_GOALS isn't exported, so duplicate here to keep variants
// self-contained.)
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

// ─── V1 — Year band on top ─────────────────────────────────────────────
// Horizontal scrollable strip of year goals sits above the month title.
// Tap a pill → modal with the goal in its full form. Visually slim so
// the month grid stays the hero.
function AtelierYearBand() {
  const C = YEAR_PALETTES.light;
  const [open, setOpen] = React.useState(null); // year goal id

  const goalById = (id) => YEAR_GOALS.find((g) => g.id === id);

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: YEAR_SANS, position: 'relative',
    }}>
      <YStatusBar C={C} />

      {/* Year band */}
      <div style={{
        padding: '12px 0 14px', flexShrink: 0,
        borderBottom: `1px solid ${C.rule}`,
      }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between',
          alignItems: 'baseline', padding: '0 22px 10px',
        }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.8,
            textTransform: 'uppercase', color: C.sub, fontWeight: 600,
          }}>2026 · north stars</span>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9, color: C.mute, letterSpacing: 1,
          }}>{YEAR_GOALS.length} GOALS</span>
        </div>
        <div style={{
          display: 'flex', gap: 8, padding: '0 22px',
          overflowX: 'auto', scrollbarWidth: 'none',
        }}>
          {YEAR_GOALS.map((g) => (
            <button key={g.id} onClick={() => setOpen(g.id)}
              style={{
                flex: '0 0 auto', maxWidth: 220,
                background: C.yearBg, border: `1px solid ${C.rule}`,
                borderRadius: 12, padding: '10px 12px',
                display: 'flex', flexDirection: 'column',
                alignItems: 'flex-start', gap: 4, cursor: 'pointer',
                fontFamily: 'inherit', textAlign: 'left',
              }}>
              <span style={{
                fontFamily: YEAR_MONO, fontSize: 8.5, letterSpacing: 1.6,
                textTransform: 'uppercase', color: C.mute, fontWeight: 600,
              }}>{g.area}</span>
              <span style={{
                fontFamily: YEAR_DISPLAY, fontSize: 13.5, lineHeight: 1.2,
                fontWeight: 400, letterSpacing: -0.2, color: C.ink,
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                maxWidth: 196,
              }}>{g.title}</span>
            </button>
          ))}
        </div>
      </div>

      <YMonthHead C={C} />

      <YPocketGrid C={C} areas={Y_AREAS} goals={Y_INITIAL_GOALS}
        scrollPad="12px 22px 20px" />

      {/* Year goal modal */}
      {open && (() => {
        const g = goalById(open);
        return (
          <div onClick={() => setOpen(null)} style={{
            position: 'absolute', inset: 0, background: 'rgba(0,0,0,0.4)',
            display: 'flex', alignItems: 'flex-end', zIndex: 20,
            animation: 'fadein .2s ease-out',
          }}>
            <div onClick={(e) => e.stopPropagation()} style={{
              width: '100%', background: C.bg,
              borderRadius: '16px 16px 0 0', padding: '20px 22px 28px',
              borderTop: `1px solid ${C.rule}`,
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between',
                alignItems: 'baseline', marginBottom: 12 }}>
                <span style={{
                  fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.8,
                  textTransform: 'uppercase', color: C.sub, fontWeight: 600,
                }}>{g.area} · 2026</span>
                <button onClick={() => setOpen(null)} style={{
                  background: 'transparent', border: 'none', color: C.sub,
                  fontSize: 18, cursor: 'pointer', padding: 0,
                }}>×</button>
              </div>
              <div style={{
                fontFamily: YEAR_DISPLAY, fontSize: 24, lineHeight: 1.15,
                letterSpacing: -0.5, color: C.ink, marginBottom: 14,
              }}>{g.title}</div>
              <div style={{
                fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.4,
                textTransform: 'uppercase', color: C.mute,
              }}>this month, in {g.area.toLowerCase()}</div>
              <div style={{ marginTop: 8, display: 'flex',
                flexDirection: 'column', gap: 5 }}>
                {Y_INITIAL_GOALS.filter((x) => x.area === g.area).slice(0, 4).map((x) => (
                  <div key={x.id} style={{
                    background: C.chip, border: `1px solid ${C.rule}`,
                    borderRadius: 8, padding: '8px 10px',
                    fontFamily: YEAR_DISPLAY, fontSize: 13, color: C.ink,
                  }}>{x.title}</div>
                ))}
                {Y_INITIAL_GOALS.filter((x) => x.area === g.area).length === 0 && (
                  <div style={{
                    fontFamily: YEAR_MONO, fontSize: 10, color: C.mute,
                    letterSpacing: 1.2, padding: '8px 0',
                  }}>NOTHING THIS MONTH</div>
                )}
              </div>
            </div>
          </div>
        );
      })()}
    </div>
  );
}
window.AtelierYearBand = AtelierYearBand;


// ─── V2 — Swipe-up year sheet ──────────────────────────────────────────
// Month grid by default. A small handle at the bottom (or tapping the
// year label) reveals a full-screen "2026" sheet that uses the same
// pocket layout but with year goals. Swipe/tap the handle to dismiss.
function AtelierYearSheet() {
  const C = YEAR_PALETTES.light;
  const [sheet, setSheet] = React.useState(false);

  const yearByArea = (area) => YEAR_GOALS.find((g) => g.area === area);

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: YEAR_SANS, position: 'relative',
    }}>
      <YStatusBar C={C} />
      <YMonthHead C={C} right={
        <button onClick={() => setSheet(true)} style={{
          background: 'transparent', border: `1px solid ${C.rule}`,
          color: C.sub, padding: '4px 9px', borderRadius: 999,
          fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.4,
          textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
        }}>2026 ↑</button>
      } />

      <YPocketGrid C={C} areas={Y_AREAS} goals={Y_INITIAL_GOALS}
        scrollPad="12px 22px 20px" />

      {/* Year sheet */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        height: '100%',
        background: C.bg, zIndex: 10,
        transform: sheet ? 'translateY(0)' : 'translateY(100%)',
        transition: 'transform .35s cubic-bezier(0.32, 0.72, 0, 1)',
        display: 'flex', flexDirection: 'column',
        boxShadow: sheet ? '0 -20px 60px rgba(0,0,0,0.15)' : 'none',
      }}>
        <YStatusBar C={C} />
        <div style={{
          padding: '14px 22px 0', display: 'flex',
          justifyContent: 'space-between', alignItems: 'baseline', flexShrink: 0,
        }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
            <span style={{
              fontFamily: YEAR_DISPLAY, fontSize: 24, fontStyle: 'italic',
              fontWeight: 400, letterSpacing: -0.5, color: C.ink,
            }}>2026</span>
            <span style={{
              fontFamily: YEAR_MONO, fontSize: 10, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>north stars</span>
          </div>
          <button onClick={() => setSheet(false)} style={{
            background: 'transparent', border: `1px solid ${C.rule}`,
            color: C.sub, padding: '4px 9px', borderRadius: 999,
            fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.4,
            textTransform: 'uppercase', cursor: 'pointer', fontWeight: 600,
          }}>May ↓</button>
        </div>

        <div style={{ flex: 1, overflow: 'auto', padding: '12px 22px 30px' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
            {Y_AREAS.filter((a) => a !== 'Open').map((area) => {
              const yg = yearByArea(area);
              return (
                <div key={area} style={{
                  background: yg ? C.yearBg : C.bg,
                  border: `1px solid ${yg ? C.starBorder : C.rule}`,
                  borderRadius: 14, padding: '14px 14px 16px',
                  display: 'flex', flexDirection: 'column', gap: 8,
                  minHeight: 130, minWidth: 0,
                }}>
                  <span style={{
                    fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.8,
                    textTransform: 'uppercase', color: C.sub, fontWeight: 600,
                  }}>{area}</span>
                  {yg ? (
                    <span style={{
                      fontFamily: YEAR_DISPLAY, fontSize: 16, lineHeight: 1.2,
                      letterSpacing: -0.3, color: C.ink, fontWeight: 400,
                    }}>{yg.title}</span>
                  ) : (
                    <button style={{
                      background: 'transparent', border: `1px dashed ${C.rule}`,
                      borderRadius: 10, padding: '14px 10px',
                      fontFamily: YEAR_MONO, fontSize: 9.5, letterSpacing: 1.2,
                      textTransform: 'uppercase', color: C.mute, cursor: 'pointer',
                      marginTop: 'auto',
                    }}>+ add</button>
                  )}
                </div>
              );
            })}
          </div>
          <div style={{
            marginTop: 18, padding: '8px 6px',
            fontFamily: YEAR_MONO, fontSize: 9, color: C.mute,
            letterSpacing: 1.4, textAlign: 'center',
          }}>SWIPE DOWN TO RETURN TO MAY</div>
        </div>
      </div>
    </div>
  );
}
window.AtelierYearSheet = AtelierYearSheet;


// ─── V3 — Year goal embedded in each pocket ────────────────────────────
// Each pocket card carries its own year goal as a quiet header line
// above the month items. Tightest visual coupling — you literally
// always see the year goal next to the work for it.
function AtelierYearInPocket() {
  const C = YEAR_PALETTES.light;

  const yearByArea = (area) => YEAR_GOALS.find((g) => g.area === area);
  const pockets = Y_AREAS.map((area) => ({
    area, items: Y_INITIAL_GOALS.filter((g) => g.area === area), year: yearByArea(area),
  }));

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: YEAR_SANS, position: 'relative',
    }}>
      <YStatusBar C={C} />
      <YMonthHead C={C} />

      <div style={{ flex: 1, overflow: 'auto', padding: '12px 22px 20px' }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between',
          alignItems: 'baseline', marginBottom: 8,
        }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.6,
            textTransform: 'uppercase', color: C.mute, fontWeight: 600,
          }}>each pocket carries its 2026 north star</span>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
          {pockets.map((p) => (
            <YPocketWithYear key={p.area} p={p} C={C} />
          ))}
        </div>
      </div>
    </div>
  );
}

function YPocketWithYear({ p, C }) {
  const empty = p.items.length === 0;
  return (
    <div style={{
      background: C.pocket, border: `1px solid ${C.rule}`, borderRadius: 14,
      padding: '10px 10px', display: 'flex', flexDirection: 'column', gap: 6,
      minHeight: 130, minWidth: 0, cursor: 'pointer',
    }}>
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

      {/* Year line — quiet, italic, serif */}
      {p.year ? (
        <div style={{
          padding: '0 4px 6px',
          borderBottom: `1px dashed ${C.rule}`,
          marginBottom: 2,
        }}>
          <div style={{
            fontFamily: YEAR_MONO, fontSize: 8, letterSpacing: 1.6,
            textTransform: 'uppercase', color: C.mute, fontWeight: 600,
            marginBottom: 2,
          }}>2026</div>
          <div style={{
            fontFamily: YEAR_DISPLAY, fontSize: 12, fontStyle: 'italic',
            lineHeight: 1.25, color: C.sub, fontWeight: 400,
            overflow: 'hidden', textOverflow: 'ellipsis',
            display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical',
          }}>{p.year.title}</div>
        </div>
      ) : (
        <div style={{
          padding: '4px 4px 6px',
          borderBottom: `1px dashed ${C.rule}`,
          marginBottom: 2,
          fontFamily: YEAR_MONO, fontSize: 8.5, letterSpacing: 1.4,
          textTransform: 'uppercase', color: C.mute,
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
              letterSpacing: -0.2, lineHeight: 1.25,
              color: g.star ? C.starInk : C.ink,
              display: 'flex', alignItems: 'center', gap: 6, minWidth: 0,
            }}>
              {g.star && <span style={{ color: C.starInk, fontSize: 9, flexShrink: 0 }}>★</span>}
              <span style={{
                overflow: 'hidden', textOverflow: 'ellipsis',
                whiteSpace: 'nowrap', minWidth: 0,
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
window.AtelierYearInPocket = AtelierYearInPocket;


// ─── V3 — Detail screen ────────────────────────────────────────────────
// Companion to AtelierYearInPocket. When you tap into a pocket you see
// the 2026 north star displayed as a banner statement at the top — the
// frame for everything below — then the month items list. Body pocket
// chosen as a representative example.
function AtelierYearInPocketDetail() {
  const C = YEAR_PALETTES.light;
  const area = 'Body';
  const yg = YEAR_GOALS.find((g) => g.area === area);
  const items = Y_INITIAL_GOALS.filter((g) => g.area === area);

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: YEAR_SANS, position: 'relative',
    }}>
      <YStatusBar C={C} />

      {/* Top bar with back and title */}
      <div style={{ padding: '14px 22px 10px', flexShrink: 0,
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
      }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
          <button style={{
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

      {/* Year banner — the north star as the page's frame */}
      <div style={{
        margin: '4px 22px 0',
        background: C.yearBg,
        border: `1px solid ${C.starBorder}`,
        borderRadius: 14,
        padding: '14px 16px 16px',
        flexShrink: 0,
      }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between',
          alignItems: 'baseline', marginBottom: 8,
        }}>
          <span style={{
            fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.8,
            textTransform: 'uppercase', color: C.sub, fontWeight: 600,
          }}>2026 · north star</span>
          <button style={{
            background: 'transparent', border: 'none', color: C.mute,
            fontFamily: YEAR_MONO, fontSize: 9, letterSpacing: 1.4,
            textTransform: 'uppercase', cursor: 'pointer', padding: 0,
            fontWeight: 600,
          }}>edit</button>
        </div>
        <div style={{
          fontFamily: YEAR_DISPLAY, fontSize: 20, lineHeight: 1.2,
          letterSpacing: -0.4, color: C.ink, fontWeight: 400,
        }}>{yg ? yg.title : <span style={{ fontStyle: 'italic', color: C.mute }}>No 2026 goal yet · tap to add</span>}</div>
      </div>

      {/* Section divider */}
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

      {/* Month items list */}
      <div style={{ flex: 1, overflow: 'auto', padding: '0 22px 80px' }}>
        {items.map((g, i) => (
          <YDetailGoal key={g.id} g={g} C={C}
            isLast={i === items.length - 1} />
        ))}
      </div>

      {/* Add bar — pinned bottom */}
      <div style={{
        position: 'absolute', left: 14, right: 14, bottom: 14,
        background: C.pocket, border: `1px solid ${C.rule}`,
        borderRadius: 14, padding: '8px 10px',
        display: 'flex', alignItems: 'center', gap: 8,
        boxShadow: '0 8px 24px rgba(0,0,0,0.06)',
      }}>
        <button style={{
          flex: 1, background: 'transparent', border: 'none', cursor: 'pointer',
          fontFamily: YEAR_MONO, fontSize: 10, letterSpacing: 1.4,
          textTransform: 'uppercase', color: C.sub, fontWeight: 600,
          padding: '8px 6px', textAlign: 'left',
        }}>+ Add to {area}</button>
      </div>
    </div>
  );
}

function YDetailGoal({ g, C, isLast }) {
  return (
    <div style={{
      padding: '16px 14px',
      margin: '0 -14px',
      borderRadius: g.star ? 12 : 0,
      background: g.star ? C.starBg : 'transparent',
      borderBottom: isLast ? 'none' : `1px solid ${g.star ? 'transparent' : C.rule}`,
    }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
        <span style={{
          color: g.star ? C.starInk : C.mute, fontSize: 12,
          padding: 2, lineHeight: 1, marginTop: 6,
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
    </div>
  );
}

window.AtelierYearInPocketDetail = AtelierYearInPocketDetail;

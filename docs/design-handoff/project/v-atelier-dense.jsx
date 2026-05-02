// Atelier Dense — same visual language as the wall, but compressed
// so multiple areas are visible without scrolling. Each area becomes
// a horizontal band: name on the left, goals flowing right.
// Weight still drives prominence, but spatially tighter.

const DENSE_PALETTES = {
  light: {
    bg: '#ffffff', ink: '#0a0a0a', sub: '#525252', mute: '#a3a3a3',
    rule: '#ededed', accent: '#0a0a0a', chip: '#fafafa',
  },
  dark: {
    bg: '#0a0a0a', ink: '#fafafa', sub: '#a3a3a3', mute: '#525252',
    rule: '#1f1f1f', accent: '#9bf00b', chip: '#141414',
  },
};

const DENSE_GOALS = [
  { area: 'Work',   weight: 'L', title: 'Ship side project v0.1', detail: 'Quiet launch, month-end' },
  { area: 'Body',   weight: 'L', title: 'Sub-25 5K',              detail: 'PB 26:14 · final weekend' },
  { area: 'Work',   weight: 'M', title: '€500 to brokerage',      detail: 'Auto-transfer set' },
  { area: 'Body',   weight: 'M', title: 'Strength 3× / week',     detail: 'Push · pull · legs' },
  { area: 'Mind',   weight: 'L', title: 'Beginning of Infinity',  detail: 'Deutsch · finish' },
  { area: 'Mind',   weight: 'S', title: 'Severance S2',           detail: 'Tue evenings' },
  { area: 'Skill',  weight: 'M', title: 'Rust ownership',         detail: 'Rust in Action ch. 4–7' },
  { area: 'Skill',  weight: 'S', title: 'Italian A2',             detail: 'Pimsleur 14–20' },
  { area: 'Skill',  weight: 'S', title: 'Tonal harmony',          detail: '15m at piano' },
  { area: 'Daily',  weight: 'M', title: 'Read 20m before bed',    detail: 'No exceptions' },
  { area: 'Daily',  weight: 'S', title: 'No phone before 9am',    detail: 'Weekdays' },
  { area: 'Daily',  weight: 'S', title: 'Cook at home 5×',        detail: '' },
  { area: 'Play',   weight: 'M', title: 'Silksong main story',    detail: '' },
  { area: 'Play',   weight: 'S', title: 'Elden DLC w/ Mark',      detail: 'Sundays' },
  { area: 'Life',   weight: 'M', title: 'Renew passport',         detail: 'Before 20th' },
  { area: 'Life',   weight: 'S', title: 'Lisbon trip',            detail: 'Book flights' },
  { area: 'Life',   weight: 'S', title: 'Tax filing',             detail: 'Due 31st' },
];

const DENSE_AREA_ORDER = ['Work', 'Body', 'Mind', 'Skill', 'Daily', 'Play', 'Life'];

function AtelierDense() {
  const [theme, setTheme] = React.useState('light');
  const C = DENSE_PALETTES[theme];
  const isDark = theme === 'dark';

  const display = '"Fraunces", "Instrument Serif", Georgia, serif';
  const sans = '"Inter", ui-sans-serif, system-ui, sans-serif';
  const mono = '"JetBrains Mono", ui-monospace, monospace';

  const grouped = DENSE_AREA_ORDER
    .map((area) => ({ area, items: DENSE_GOALS.filter((g) => g.area === area) }))
    .filter((g) => g.items.length > 0);

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: sans, transition: 'background .25s, color .25s',
    }}>
      {/* status */}
      <div style={{
        height: 36, padding: '0 22px', display: 'flex',
        alignItems: 'center', justifyContent: 'space-between',
        fontSize: 13, fontWeight: 600, color: C.ink, flexShrink: 0,
      }}>
        <span>9:41</span>
        <span style={{ fontSize: 11, opacity: 0.7 }}>●●●● · 86%</span>
      </div>

      {/* TOP BAR — preserved */}
      <div style={{ padding: '14px 22px 16px', flexShrink: 0 }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          marginBottom: 14,
        }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
            <span style={{
              fontFamily: display, fontSize: 24, fontStyle: 'italic',
              fontWeight: 400, letterSpacing: -0.5, color: C.ink,
            }}>May</span>
            <span style={{
              fontFamily: mono, fontSize: 10, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>2026</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <span style={{
              fontFamily: mono, fontSize: 10, color: C.sub,
              letterSpacing: 1.4,
            }}>
              <span style={{ color: C.ink, fontWeight: 600 }}>{daysLeft}</span>
              <span style={{ color: C.mute }}> DAYS LEFT</span>
            </span>
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
          </div>
        </div>

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
      </div>

      {/* DENSE BANDS — area as left gutter, goals horizontal-scroll */}
      <div style={{ flex: 1, overflow: 'auto' }}>
        {grouped.map((g, gi) => (
          <DenseBand
            key={g.area} area={g.area} items={g.items}
            C={C} display={display} mono={mono} sans={sans}
            isFirst={gi === 0}
          />
        ))}
        <div style={{ height: 16 }}/>
      </div>
    </div>
  );
}

function DenseBand({ area, items, C, display, mono, sans, isFirst }) {
  return (
    <div style={{
      display: 'grid', gridTemplateColumns: '54px 1fr',
      gap: 10, padding: '12px 0 12px 22px',
      borderTop: isFirst ? 'none' : `1px solid ${C.rule}`,
      alignItems: 'start',
    }}>
      {/* area label — left gutter, vertical anchor */}
      <div style={{
        paddingTop: 6, lineHeight: 1.2,
      }}>
        <div style={{
          fontFamily: mono, fontSize: 9, letterSpacing: 1.8,
          textTransform: 'uppercase', color: C.sub, fontWeight: 600,
        }}>{area}</div>
        <div style={{
          fontFamily: mono, fontSize: 9, color: C.mute, marginTop: 2,
        }}>{String(items.length).padStart(2, '0')}</div>
      </div>

      {/* horizontal flow of goals — peek-and-scroll */}
      <div style={{
        display: 'flex', gap: 8, overflowX: 'auto',
        paddingRight: 22, paddingBottom: 2,
        scrollSnapType: 'x proximity',
      }}>
        {items.map((g, i) => (
          <DenseGoal key={i} g={g} C={C}
            display={display} mono={mono} sans={sans} />
        ))}
      </div>
    </div>
  );
}

function DenseGoal({ g, C, display, mono, sans }) {
  const cfg = {
    L: { width: 200, titleSize: 15, padY: 10, padX: 12, height: 78 },
    M: { width: 160, titleSize: 13, padY: 9,  padX: 11, height: 78 },
    S: { width: 130, titleSize: 12, padY: 9,  padX: 11, height: 78 },
  }[g.weight];

  return (
    <div style={{
      flex: `0 0 ${cfg.width}px`,
      width: cfg.width, height: cfg.height,
      padding: `${cfg.padY}px ${cfg.padX}px`,
      background: C.chip,
      border: `1px solid ${C.rule}`,
      borderRadius: 12,
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
      scrollSnapAlign: 'start',
    }}>
      <div style={{
        fontFamily: display, fontSize: cfg.titleSize, fontWeight: 400,
        letterSpacing: -0.2, lineHeight: 1.18, color: C.ink,
      }}>{g.title}</div>
      {g.detail && (
        <div style={{
          fontFamily: sans, fontSize: 10.5, color: C.sub,
          fontWeight: 400, lineHeight: 1.35,
          overflow: 'hidden', textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}>{g.detail}</div>
      )}
    </div>
  );
}

window.AtelierDense = AtelierDense;

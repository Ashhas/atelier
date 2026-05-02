// Dark + Light Bento — main view + Wheel toggle, with resizable/draggable grid.

const THEMES = {
  dark: {
    bg: '#0b0b0e',
    card: '#15151a',
    cardHi: '#1c1c22',
    fg: '#ffffff',          // titles - pure white
    fgSoft: '#d1d1d6',       // secondary
    meta: '#9ca3af',         // meta - clearly dimmer but readable
    dim: '#71717a',
    hair: '#2a2a32',
    counter: '#fbbf24',
  },
  light: {
    bg: '#f4f4f0',
    card: '#ffffff',
    cardHi: '#fafaf7',
    fg: '#0a0a0c',           // titles - near black
    fgSoft: '#3f3f46',
    meta: '#525866',         // meta - clearly dimmer but readable
    dim: '#71717a',
    hair: '#e4e4e0',
    counter: '#b45309',      // amber adjusted for light
  },
};

const V2_CAT = {
  dark: {
    games:    '#a78bfa',
    actions:  '#fb923c',
    learn:    '#60a5fa',
    achieve:  '#fbbf24',
    routines: '#34d399',
    health:   '#f472b6',
    media:    '#22d3ee',
    free:     '#a3a3a3',
  },
  light: {
    games:    '#7c3aed',
    actions:  '#ea580c',
    learn:    '#2563eb',
    achieve:  '#b45309',
    routines: '#059669',
    health:   '#db2777',
    media:    '#0891b2',
    free:     '#525866',
  },
};

const COLS = 4;
const ROW_H = 110;

const DEFAULT_LAYOUT = {
  games:    { x: 0, y: 0, w: 4, h: 1 },
  actions:  { x: 0, y: 1, w: 2, h: 1 },
  learn:    { x: 2, y: 1, w: 2, h: 1 },
  achieve:  { x: 0, y: 2, w: 2, h: 2 },
  routines: { x: 2, y: 2, w: 2, h: 1 },
  health:   { x: 2, y: 3, w: 2, h: 1 },
  media:    { x: 0, y: 4, w: 2, h: 1 },
  free:     { x: 2, y: 4, w: 2, h: 1 },
};

function VariantDarkBento() {
  const [view, setView] = React.useState('bento');
  const [edit, setEdit] = React.useState(false);
  const [layout, setLayout] = React.useState(DEFAULT_LAYOUT);
  const [theme, setTheme] = React.useState('dark');
  const T = THEMES[theme];
  const C = V2_CAT[theme];

  return (
    <div style={{
      width: '100%', height: '100%', background: T.bg, color: T.fg,
      fontFamily: '"Inter", ui-sans-serif, system-ui, sans-serif',
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <V2Status T={T} />

      {/* hero */}
      <div style={{ padding: '4px 18px 12px',
        display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12 }}>
        <div>
          <div style={{ fontSize: 11, color: T.meta, fontWeight: 600, letterSpacing: 1.5,
            textTransform: 'uppercase' }}>This month</div>
          <div style={{ fontSize: 30, fontWeight: 700, letterSpacing: -0.8, marginTop: 2,
            color: T.fg }}>
            May<span style={{ color: T.dim, fontWeight: 500 }}> · 2026</span>
          </div>
        </div>
        <div style={{
          background: T.cardHi, borderRadius: 14, padding: '10px 14px',
          border: `1px solid ${T.hair}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: 22, fontWeight: 800, color: T.counter,
              letterSpacing: -0.5, lineHeight: 1 }}>{daysLeft}</div>
            <div style={{ fontSize: 9, color: T.meta, fontWeight: 700,
              letterSpacing: 1, textTransform: 'uppercase', marginTop: 3 }}>days left</div>
          </div>
          <div style={{
            display: 'grid', gridTemplateColumns: 'repeat(7, 4px)',
            gridAutoRows: '4px', gap: 2,
          }}>
            {Array.from({ length: MONTH.daysInMonth }).map((_, i) => (
              <span key={i} style={{
                width: 4, height: 4, borderRadius: 1,
                background: i < dayOfMonth ? T.counter : T.hair,
              }}/>
            ))}
          </div>
        </div>
      </div>

      {/* tab bar */}
      <div style={{ padding: '0 18px 12px',
        display: 'flex', gap: 6, alignItems: 'center' }}>
        <Tab T={T} active={view === 'bento'} onClick={() => setView('bento')} label="Bento"/>
        <Tab T={T} active={view === 'wheel'} onClick={() => setView('wheel')} label="Wheel"/>
        <span style={{ flex: 1 }}/>
        {/* theme toggle */}
        <button onClick={() => setTheme((t) => t === 'dark' ? 'light' : 'dark')}
          title="Toggle theme"
          style={{
            background: T.cardHi, color: T.fg, border: `1px solid ${T.hair}`,
            width: 30, height: 30, borderRadius: 100,
            cursor: 'pointer', display: 'flex', alignItems: 'center',
            justifyContent: 'center', padding: 0, fontFamily: 'inherit',
          }}>
          {theme === 'dark' ? (
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
              <path d="M11 7.5A4.5 4.5 0 0 1 6.5 3 4.5 4.5 0 1 0 11 7.5z"
                fill={T.fg}/>
            </svg>
          ) : (
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={T.fg} strokeWidth="1.5">
              <circle cx="7" cy="7" r="2.5" fill={T.fg}/>
              <path d="M7 1v1.5M7 11.5V13M1 7h1.5M11.5 7H13M2.8 2.8l1 1M10.2 10.2l1 1M2.8 11.2l1-1M10.2 3.8l1-1"
                strokeLinecap="round"/>
            </svg>
          )}
        </button>
        {view === 'bento' && (
          <button onClick={() => setEdit((e) => !e)}
            style={{
              background: edit ? T.counter : T.cardHi,
              color: edit ? T.bg : T.fg,
              border: `1px solid ${edit ? T.counter : T.hair}`,
              padding: '6px 12px', borderRadius: 100,
              fontSize: 11, fontWeight: 700, letterSpacing: 0.5,
              cursor: 'pointer', textTransform: 'uppercase',
              fontFamily: 'inherit',
            }}>
            {edit ? 'Done' : 'Edit'}
          </button>
        )}
      </div>

      {/* content */}
      <div style={{ flex: 1, overflow: 'auto', padding: '0 14px 24px' }}>
        {view === 'bento'
          ? <BentoGrid T={T} C={C} layout={layout} setLayout={setLayout} edit={edit} />
          : <WheelView T={T} C={C} />}
      </div>
    </div>
  );
}

function Tab({ T, active, onClick, label }) {
  return (
    <button onClick={onClick}
      style={{
        background: active ? T.fg : 'transparent',
        color: active ? T.bg : T.meta,
        border: `1px solid ${active ? T.fg : T.hair}`,
        padding: '6px 14px', borderRadius: 100,
        fontSize: 12, fontWeight: 700, letterSpacing: 0.3,
        cursor: 'pointer', fontFamily: 'inherit',
      }}>{label}</button>
  );
}

function BentoGrid({ T, C, layout, setLayout, edit }) {
  const containerRef = React.useRef(null);
  const [cellW, setCellW] = React.useState(0);
  const GAP = 8;

  React.useEffect(() => {
    const measure = () => {
      if (!containerRef.current) return;
      const w = containerRef.current.clientWidth;
      setCellW((w - GAP * (COLS - 1)) / COLS);
    };
    measure();
    const ro = new ResizeObserver(measure);
    if (containerRef.current) ro.observe(containerRef.current);
    return () => ro.disconnect();
  }, []);

  const maxRow = Math.max(...Object.values(layout).map((l) => l.y + l.h));
  const totalH = maxRow * ROW_H + (maxRow - 1) * GAP;

  const update = (key, patch) => {
    setLayout((L) => ({ ...L, [key]: { ...L[key], ...patch } }));
  };

  return (
    <div ref={containerRef} style={{
      position: 'relative', width: '100%', minHeight: totalH,
    }}>
      {edit && cellW > 0 && (
        <div style={{
          position: 'absolute', inset: 0, pointerEvents: 'none',
          backgroundImage: `
            linear-gradient(to right, ${T.hair} 1px, transparent 1px),
            linear-gradient(to bottom, ${T.hair} 1px, transparent 1px)`,
          backgroundSize: `${cellW + GAP}px 100%, 100% ${ROW_H + GAP}px`,
          opacity: 0.6,
        }}/>
      )}

      {Object.entries(COMMITMENTS).map(([key, cat]) => {
        const l = layout[key];
        if (!l || cellW === 0) return null;
        const left = l.x * (cellW + GAP);
        const top = l.y * (ROW_H + GAP);
        const width = l.w * cellW + (l.w - 1) * GAP;
        const height = l.h * ROW_H + (l.h - 1) * GAP;
        return (
          <BentoTile
            key={key} T={T} C={C} catKey={key} cat={cat}
            left={left} top={top} width={width} height={height}
            edit={edit}
            onMove={(dx, dy) => {
              const nx = Math.max(0, Math.min(COLS - l.w, Math.round(l.x + dx / (cellW + GAP))));
              const ny = Math.max(0, Math.round(l.y + dy / (ROW_H + GAP)));
              update(key, { x: nx, y: ny });
            }}
            onResize={(dw, dh) => {
              const nw = Math.max(1, Math.min(COLS - l.x, Math.round(l.w + dw / (cellW + GAP))));
              const nh = Math.max(1, Math.round(l.h + dh / (ROW_H + GAP)));
              update(key, { w: nw, h: nh });
            }}
          />
        );
      })}
    </div>
  );
}

function BentoTile({ T, C, catKey, cat, left, top, width, height, edit, onMove, onResize }) {
  const tintColor = C[catKey];
  const startMove = (e) => {
    if (!edit) return;
    e.preventDefault(); e.stopPropagation();
    const sx = e.clientX, sy = e.clientY;
    const move = (ev) => onMove(ev.clientX - sx, ev.clientY - sy);
    const up = () => {
      document.removeEventListener('pointermove', move);
      document.removeEventListener('pointerup', up);
    };
    document.addEventListener('pointermove', move);
    document.addEventListener('pointerup', up);
  };
  const startResize = (e) => {
    e.preventDefault(); e.stopPropagation();
    const sx = e.clientX, sy = e.clientY;
    let lastDx = 0, lastDy = 0;
    const move = (ev) => {
      const dx = ev.clientX - sx, dy = ev.clientY - sy;
      onResize(dx - lastDx, dy - lastDy);
      lastDx = dx; lastDy = dy;
    };
    const up = () => {
      document.removeEventListener('pointermove', move);
      document.removeEventListener('pointerup', up);
    };
    document.addEventListener('pointermove', move);
    document.addEventListener('pointerup', up);
  };

  const dense = height < 130 || width < 140;

  return (
    <div
      onPointerDown={startMove}
      style={{
        position: 'absolute', left, top, width, height,
        background: T.card, borderRadius: 16,
        border: `1.5px solid ${tintColor}`,
        padding: 14,
        display: 'flex', flexDirection: 'column', gap: 10,
        overflow: 'hidden',
        transition: edit ? 'none' : 'all 0.18s ease',
        cursor: edit ? 'grab' : 'default',
        boxSizing: 'border-box',
      }}>
      {/* header */}
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        flexShrink: 0,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
          <span style={{
            width: 7, height: 7, borderRadius: 4, background: tintColor,
          }}/>
          <span style={{
            fontSize: 11, fontWeight: 700, letterSpacing: 1.2,
            textTransform: 'uppercase', color: tintColor,
          }}>{cat.label}</span>
        </div>
        <span style={{ fontSize: 11, color: T.meta, fontWeight: 700,
          fontVariantNumeric: 'tabular-nums' }}>
          {String(cat.items.length).padStart(2, '0')}
        </span>
      </div>

      {/* items - title strong, meta clearly subordinate */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: dense ? 6 : 9,
        overflow: 'hidden', flex: 1 }}>
        {cat.items.map((it, j) => (
          <div key={j} style={{ minWidth: 0 }}>
            <div style={{
              fontSize: 14, fontWeight: 600, lineHeight: 1.3,
              color: T.fg, letterSpacing: -0.1,
              whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
            }}>{it.title}</div>
            {it.meta && !dense && (
              <div style={{
                fontSize: 12, color: T.meta, lineHeight: 1.35, fontWeight: 400,
                marginTop: 2,
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
              }}>{it.meta}</div>
            )}
          </div>
        ))}
      </div>

      {edit && (
        <div onPointerDown={startResize}
          style={{
            position: 'absolute', right: 0, bottom: 0,
            width: 20, height: 20, cursor: 'nwse-resize',
            display: 'flex', alignItems: 'flex-end', justifyContent: 'flex-end',
            padding: 4,
          }}>
          <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
            <path d="M9 1L1 9M9 5L5 9" stroke={tintColor} strokeWidth="1.8"
              strokeLinecap="round"/>
          </svg>
        </div>
      )}
    </div>
  );
}

function WheelView({ T, C }) {
  const cats = Object.entries(COMMITMENTS);
  const N = cats.length;
  const cx = 165, cy = 165, R = 145, r = 50;
  const segs = cats.map(([key], i) => {
    const a0 = (i / N) * Math.PI * 2 - Math.PI / 2;
    const a1 = ((i + 1) / N) * Math.PI * 2 - Math.PI / 2;
    const x0 = cx + R * Math.cos(a0), y0 = cy + R * Math.sin(a0);
    const x1 = cx + R * Math.cos(a1), y1 = cy + R * Math.sin(a1);
    const xi0 = cx + r * Math.cos(a0), yi0 = cy + r * Math.sin(a0);
    const xi1 = cx + r * Math.cos(a1), yi1 = cy + r * Math.sin(a1);
    const d = `M ${xi0} ${yi0} L ${x0} ${y0} A ${R} ${R} 0 0 1 ${x1} ${y1} L ${xi1} ${yi1} A ${r} ${r} 0 0 0 ${xi0} ${yi0} Z`;
    const aMid = (a0 + a1) / 2;
    const lr = (R + r) / 2;
    const lx = cx + lr * Math.cos(aMid), ly = cy + lr * Math.sin(aMid);
    return { key, d, lx, ly, a0, a1 };
  });
  const ringR = R + 14;

  return (
    <div>
      <div style={{ margin: '0 auto', width: 330, height: 330 }}>
        <svg width="330" height="330" viewBox="0 0 330 330">
          {segs.map((s) => (
            <path key={s.key} d={s.d}
              fill={C[s.key]} fillOpacity="0.10"
              stroke={C[s.key]} strokeWidth="1" strokeOpacity="0.7"/>
          ))}
          {Array.from({ length: MONTH.daysInMonth }).map((_, i) => {
            const a = (i / MONTH.daysInMonth) * Math.PI * 2 - Math.PI / 2;
            const x = cx + ringR * Math.cos(a), y = cy + ringR * Math.sin(a);
            const past = i < dayOfMonth;
            const today = i === dayOfMonth - 1;
            return (
              <circle key={i} cx={x} cy={y}
                r={today ? 3 : 1.5}
                fill={today ? T.counter : (past ? T.counter : T.hair)}
                opacity={past && !today ? 0.5 : 1}/>
            );
          })}
          {segs.map((s) => {
            const cat = COMMITMENTS[s.key];
            return (
              <text key={s.key} x={s.lx} y={s.ly}
                fill={C[s.key]} fontSize="9" fontWeight="700"
                textAnchor="middle" dominantBaseline="middle"
                letterSpacing="1">
                {cat.label.toUpperCase()}
              </text>
            );
          })}
          {segs.map((s) => {
            const cat = COMMITMENTS[s.key];
            const seg = (s.a1 - s.a0);
            return cat.items.map((_, i) => {
              const t = (i + 1) / (cat.items.length + 1);
              const a = s.a0 + seg * t;
              const dr = R - 18;
              const x = cx + dr * Math.cos(a), y = cy + dr * Math.sin(a);
              return <circle key={`${s.key}-${i}`} cx={x} cy={y} r="2.5" fill={C[s.key]}/>;
            });
          })}
          <circle cx={cx} cy={cy} r={r - 2} fill={T.bg}
            stroke={T.hair} strokeWidth="1"/>
          <text x={cx} y={cy - 6} fill={T.fg} fontSize="22" fontWeight="800"
            textAnchor="middle" letterSpacing="-0.5">{TOTAL_COUNT}</text>
          <text x={cx} y={cy + 11} fill={T.meta} fontSize="8" fontWeight="700"
            textAnchor="middle" letterSpacing="1.5">COMMITMENTS</text>
        </svg>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 6,
        marginTop: 12 }}>
        {Object.entries(COMMITMENTS).map(([key, cat]) => (
          <div key={key} style={{
            padding: '8px 10px', background: T.card,
            border: `1.5px solid ${C[key]}`, borderRadius: 10,
            display: 'flex', alignItems: 'center', gap: 8,
          }}>
            <span style={{ width: 7, height: 7, borderRadius: 4,
              background: C[key], flexShrink: 0 }}/>
            <span style={{ fontSize: 12, fontWeight: 600, flex: 1, color: T.fg }}>{cat.label}</span>
            <span style={{ fontSize: 11, color: C[key], fontWeight: 700 }}>
              {cat.items.length}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

function V2Status({ T }) {
  return (
    <div style={{
      height: 36, padding: '0 18px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      fontSize: 13, color: T.fg, fontWeight: 600,
    }}>
      <span>9:41</span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <span style={{ fontSize: 11, opacity: 0.8 }}>●●●● 5G</span>
        <span style={{ width: 22, height: 11, border: `1px solid ${T.fg}`, borderRadius: 2,
          position: 'relative', display: 'inline-block' }}>
          <span style={{ position: 'absolute', inset: 1, background: T.fg, width: '70%' }}/>
        </span>
      </div>
    </div>
  );
}

window.VariantDarkBento = VariantDarkBento;

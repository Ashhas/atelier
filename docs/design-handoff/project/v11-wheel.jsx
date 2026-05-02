// Variant 11 — The Wheel
// Circular at-a-glance: month is the ring, categories slice it,
// commitments orbit. Single-screen, no scroll for the wheel itself.

const v11Bg = '#0d0d11';
const v11Fg = '#f5f5f0';
const v11Dim = '#7a7a82';
const v11Hair = '#22222a';

const V11_TINT = {
  games: '#a78bfa', actions: '#fb923c', learn: '#60a5fa',
  achieve: '#fbbf24', routines: '#34d399', health: '#f472b6',
  media: '#22d3ee', free: '#a3a3a3',
};

function VariantWheel() {
  const cats = Object.entries(COMMITMENTS);
  const N = cats.length;
  const cx = 165, cy = 165, R = 145, r = 50;

  // build pie segments
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
    return { key, d, lx, ly, a0, a1, aMid };
  });

  // month ring — small dots around outside
  const ringR = R + 14;

  return (
    <div style={{
      width: '100%', height: '100%', background: v11Bg, color: v11Fg,
      fontFamily: '"Inter", system-ui, sans-serif',
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <V11Status />

      <div style={{ padding: '4px 22px 8px',
        display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <div style={{ fontSize: 10, color: v11Dim, fontWeight: 600,
            letterSpacing: 2, textTransform: 'uppercase' }}>The wheel</div>
          <div style={{ fontSize: 24, fontWeight: 700, letterSpacing: -0.6, marginTop: 2 }}>
            May 2026
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{ fontSize: 24, fontWeight: 800, color: '#fbbf24',
            letterSpacing: -0.5, lineHeight: 1 }}>{daysLeft}</div>
          <div style={{ fontSize: 9, color: v11Dim, fontWeight: 700,
            letterSpacing: 1.5, textTransform: 'uppercase' }}>days left</div>
        </div>
      </div>

      {/* wheel */}
      <div style={{
        margin: '4px auto 8px', width: 330, height: 330, position: 'relative',
      }}>
        <svg width="330" height="330" viewBox="0 0 330 330">
          {segs.map((s) => (
            <path key={s.key} d={s.d}
              fill={V11_TINT[s.key]} fillOpacity="0.14"
              stroke={V11_TINT[s.key]} strokeWidth="0.5" strokeOpacity="0.5"/>
          ))}
          {/* day ring */}
          {Array.from({ length: MONTH.daysInMonth }).map((_, i) => {
            const a = (i / MONTH.daysInMonth) * Math.PI * 2 - Math.PI / 2;
            const x = cx + ringR * Math.cos(a), y = cy + ringR * Math.sin(a);
            const past = i < dayOfMonth;
            const today = i === dayOfMonth - 1;
            return (
              <circle key={i} cx={x} cy={y}
                r={today ? 3 : 1.5}
                fill={today ? '#fbbf24' : (past ? '#fbbf24' : v11Hair)}
                opacity={past && !today ? 0.5 : 1}/>
            );
          })}
          {/* segment labels */}
          {segs.map((s) => {
            const cat = COMMITMENTS[s.key];
            return (
              <text key={s.key} x={s.lx} y={s.ly}
                fill={V11_TINT[s.key]} fontSize="9" fontWeight="700"
                textAnchor="middle" dominantBaseline="middle"
                letterSpacing="1"
                style={{ textTransform: 'uppercase' }}>
                {cat.label.toUpperCase()}
              </text>
            );
          })}
          {/* commitment dots inside each segment */}
          {segs.map((s) => {
            const cat = COMMITMENTS[s.key];
            const seg = (s.a1 - s.a0);
            return cat.items.map((_, i) => {
              const t = (i + 1) / (cat.items.length + 1);
              const a = s.a0 + seg * t;
              const dr = R - 18;
              const x = cx + dr * Math.cos(a), y = cy + dr * Math.sin(a);
              return <circle key={i} cx={x} cy={y} r="2.5" fill={V11_TINT[s.key]}/>;
            });
          })}
          {/* center disc */}
          <circle cx={cx} cy={cy} r={r - 2} fill={v11Bg}
            stroke={v11Hair} strokeWidth="1"/>
          <text x={cx} y={cy - 6} fill={v11Fg} fontSize="22" fontWeight="800"
            textAnchor="middle" letterSpacing="-0.5">{TOTAL_COUNT}</text>
          <text x={cx} y={cy + 11} fill={v11Dim} fontSize="8" fontWeight="700"
            textAnchor="middle" letterSpacing="1.5"
            style={{ textTransform: 'uppercase' }}>commitments</text>
        </svg>
      </div>

      {/* legend - small cat list */}
      <div style={{ flex: 1, overflow: 'auto', padding: '0 16px 16px' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 6 }}>
          {cats.map(([key, cat]) => (
            <div key={key} style={{
              padding: '8px 10px', background: '#16161c',
              border: `1px solid ${v11Hair}`, borderRadius: 10,
              display: 'flex', alignItems: 'center', gap: 8,
            }}>
              <span style={{ width: 6, height: 6, borderRadius: 3,
                background: V11_TINT[key], flexShrink: 0 }}/>
              <span style={{ fontSize: 11, fontWeight: 600, flex: 1 }}>{cat.label}</span>
              <span style={{ fontSize: 11, color: v11Dim, fontWeight: 700 }}>
                {cat.items.length}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function V11Status() {
  return (
    <div style={{
      height: 36, padding: '0 22px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      fontSize: 13, color: v11Fg, fontWeight: 600,
    }}>
      <span>9:41</span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <span style={{ fontSize: 11, opacity: 0.8 }}>●●●● 5G</span>
        <span style={{ width: 22, height: 11, border: `1px solid ${v11Fg}`, borderRadius: 2,
          position: 'relative', display: 'inline-block' }}>
          <span style={{ position: 'absolute', inset: 1, background: v11Fg, width: '70%' }}/>
        </span>
      </div>
    </div>
  );
}

window.VariantWheel = VariantWheel;

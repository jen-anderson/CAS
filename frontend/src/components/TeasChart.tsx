import { getTeasCoordinates } from "../services/dataHelpers.ts";

export const TeasChart = ({ d, p, h }: { d: number, p: number, h: number }) => {
  const point = getTeasCoordinates(d, p, h);

  // Generates grid lines at 20% intervals
  const renderGrid = () => {
    const lines = [];
    for (let i = 10; i < 100; i += 10) {
      // Lines parallel to the sides
      lines.push(
        <line key={`g1-${i}`} x1={i/2} y1={86.6 - (i * 0.866)} x2={100 - i/2} y2={86.6 - (i * 0.866)} stroke="#e0e0e0" strokeWidth="0.5" />,
        <line key={`g2-${i}`} x1={i/2} y1={86.6 - (i * 0.866)} x2={i} y2={86.6} stroke="#e0e0e0" strokeWidth="0.5" />,
        <line key={`g3-${i}`} x1={100 - i/2} y1={86.6 - (i * 0.866)} x2={100 - i} y2={86.6} stroke="#e0e0e0" strokeWidth="0.5" />
      );
    }
    return lines;
  };

  return (
    <div className="teas-chart-wrapper" style={{ maxWidth: '300px', margin: '0 auto' }}>
      <svg viewBox="-23 -20 150 150">
        {renderGrid()}
        <polygon points="0,86.6 50,0 100,86.6" fill="none" stroke="#333" strokeWidth="1" />
        <circle cx={point.x} cy={point.y} r="3" fill="#ff4500" stroke="white" strokeWidth="1" />
     
     {/* Vertex Labels - Positioned relative to triangle corners */}
        <text x="50" y="-5" fontSize="5" textAnchor="middle" fontWeight="bold">Dispersion</text>
        <text x="-8" y="92" fontSize="5" textAnchor="end" fontWeight="bold">Polar</text>
        <text x="108" y="92" fontSize="5" textAnchor="start" fontWeight="bold">H-Bond</text>
     
      </svg>

    </div>
  );
};
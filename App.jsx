import React, { useEffect, useState } from 'react'

const KEY='transport-sync-v1'
const load = () => { try { return JSON.parse(localStorage.getItem(KEY) || '{}') } catch { return {} } }
const save = (d) => localStorage.setItem(KEY, JSON.stringify(d))

const empty = { settings:{currency:'BDT',company:''}, vehicles:[], income:[], expenses:[] }

export default function App(){
  const [db,setDB] = useState({...empty, ...load()})
  const [view,setView] = useState('dashboard')
  useEffect(()=> save(db), [db])

  const addVehicle = (v) => setDB(s=> ({...s, vehicles:[...s.vehicles, {...v, id:Date.now().toString()}]}))
  const addIncome = (r) => setDB(s=> ({...s, income:[...s.income, {...r, id:Date.now().toString(), amount:Number(r.amount||0)}]}))
  const addExpense = (r) => setDB(s=> ({...s, expenses:[...s.expenses, {...r, id:Date.now().toString(), amount:Number(r.amount||0)}]}))

  const totals = {
    income: db.income.reduce((a,b)=>a+Number(b.amount||0),0),
    expenses: db.expenses.reduce((a,b)=>a+Number(b.amount||0),0)
  }

  return (<div style={{fontFamily:'Arial',padding:20}}>
    <h1>Transport Sync — Prototype</h1>
    <div style={{marginBottom:10}}>
      <button onClick={()=>setView('dashboard')}>Dashboard</button>
      <button onClick={()=>setView('vehicles')}>Vehicles</button>
      <button onClick={()=>setView('income')}>Income</button>
      <button onClick={()=>setView('expenses')}>Expenses</button>
    </div>
    {view==='dashboard' && <div>
      <h3>Totals</h3>
      <div>Income: {totals.income} {db.settings.currency}</div>
      <div>Expenses: {totals.expenses} {db.settings.currency}</div>
      <div>Profit: {totals.income - totals.expenses} {db.settings.currency}</div>
    </div>}
    {view==='vehicles' && <Vehicles db={db} onAdd={addVehicle} />}
    {view==='income' && <Income db={db} onAdd={addIncome} />}
    {view==='expenses' && <Expenses db={db} onAdd={addExpense} />}
  </div>)
}

function Vehicles({db,onAdd}){
  const [f,setF]=useState({reg:'',model:'',driver:'',license:''})
  return (<div>
    <h3>Vehicles</h3>
    <input placeholder='Reg' value={f.reg} onChange={e=>setF({...f,reg:e.target.value})} />&nbsp;
    <input placeholder='Model' value={f.model} onChange={e=>setF({...f,model:e.target.value})} />&nbsp;
    <input placeholder='Driver' value={f.driver} onChange={e=>setF({...f,driver:e.target.value})} />&nbsp;
    <button onClick={()=>{ if(!f.reg) return alert('Reg required'); onAdd(f); setF({reg:'',model:'',driver:'',license:''})}}>Add</button>
    <ul>{db.vehicles.map(v=><li key={v.id}>{v.reg} • {v.model} • {v.driver}</li>)}</ul>
  </div>)
}
function Income({db,onAdd}){
  const [f,setF]=useState({date:new Date().toISOString().slice(0,10),vehicleId:'',tripNo:'',customer:'',route:'',type:'Freight',amount:0})
  return (<div>
    <h3>Income</h3>
    <input type='date' value={f.date} onChange={e=>setF({...f,date:e.target.value})} />&nbsp;
    <select value={f.vehicleId} onChange={e=>setF({...f,vehicleId:e.target.value})}>
      <option value=''>Select Vehicle</option>
      {db.vehicles.map(v=> <option key={v.id} value={v.id}>{v.reg}</option>)}
    </select>&nbsp;
    <input placeholder='Amount' type='number' value={f.amount} onChange={e=>setF({...f,amount:e.target.value})} />&nbsp;
    <button onClick={()=>{ if(!f.vehicleId||!f.amount) return alert('Vehicle & Amount required'); onAdd(f); setF({...f,tripNo:'',customer:'',route:'',amount:0}) }}>Add Income</button>
    <ul>{db.income.map(r=> <li key={r.id}>{r.date} • {r.amount} • {r.vehicleId}</li>)}</ul>
  </div>)
}
function Expenses({db,onAdd}){
  const [f,setF]=useState({date:new Date().toISOString().slice(0,10),vehicleId:'',type:'Fuel',vendor:'',qty:0,rate:0,amount:0})
  return (<div>
    <h3>Expenses</h3>
    <input type='date' value={f.date} onChange={e=>setF({...f,date:e.target.value})} />&nbsp;
    <select value={f.vehicleId} onChange={e=>setF({...f,vehicleId:e.target.value})}>
      <option value=''>Select Vehicle</option>
      {db.vehicles.map(v=> <option key={v.id} value={v.id}>{v.reg}</option>)}
    </select>&nbsp;
    <input placeholder='Amount' type='number' value={f.amount} onChange={e=>setF({...f,amount:e.target.value})} />&nbsp;
    <button onClick={()=>{ if(!f.vehicleId||!f.amount) return alert('Vehicle & Amount required'); onAdd(f); setF({...f,amount:0}) }}>Add Expense</button>
    <ul>{db.expenses.map(r=> <li key={r.id}>{r.date} • {r.amount} • {r.vehicleId}</li>)}</ul>
  </div>)
}

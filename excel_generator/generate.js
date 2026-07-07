const ExcelJS = require('exceljs');
const path = require('path');

async function createDatabaseExcel() {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Antigravity AI';
  workbook.lastModifiedBy = 'Antigravity AI';
  workbook.created = new Date();
  workbook.modified = new Date();

  // Color Palette - Slate & Teal Theme (Premium)
  const colors = {
    primaryDark: '0F172A',      // Slate 900
    primaryMedium: '1E293B',    // Slate 800
    primaryLight: '475569',     // Slate 600
    accentTeal: '0D9488',       // Teal 600
    accentTealLight: 'F0FDFA',  // Teal 50
    bgLight: 'F8FAFC',          // Slate 50
    borderLight: 'E2E8F0',      // Slate 200
    white: 'FFFFFF',
    textDark: '1E293B',
    textMuted: '64748B',
    pkColor: '1D4ED8',          // Blue 700 for PK
    fkColor: 'B45309',          // Amber 700 for FK
  };

  const thinBorder = {
    top: { style: 'thin', color: { argb: colors.borderLight } },
    left: { style: 'thin', color: { argb: colors.borderLight } },
    bottom: { style: 'thin', color: { argb: colors.borderLight } },
    right: { style: 'thin', color: { argb: colors.borderLight } }
  };

  const headerBorder = {
    top: { style: 'thin', color: { argb: colors.borderLight } },
    left: { style: 'thin', color: { argb: colors.borderLight } },
    bottom: { style: 'medium', color: { argb: colors.primaryDark } },
    right: { style: 'thin', color: { argb: colors.borderLight } }
  };

  // -------------------------------------------------------------
  // PESTAÑA 1: PORTADA & RESUMEN GENERAL
  // -------------------------------------------------------------
  const sheet1 = workbook.addWorksheet('1. Resumen General');
  sheet1.views = [{ showGridLines: false }];

  // Banner Principal
  sheet1.mergeCells('B2:H4');
  const titleCell = sheet1.getCell('B2');
  titleCell.value = 'WASHGO - MODELO DE DATOS GENERAL';
  titleCell.font = { name: 'Segoe UI', size: 16, bold: true, color: { argb: colors.white } };
  titleCell.alignment = { vertical: 'middle', horizontal: 'center' };
  titleCell.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: colors.primaryDark }
  };

  sheet1.mergeCells('B5:H5');
  const subtitleCell = sheet1.getCell('B5');
  subtitleCell.value = 'Estructura de Base de Datos Simplificada para Presentaciones';
  subtitleCell.font = { name: 'Segoe UI', size: 11, italic: true, color: { argb: colors.accentTeal } };
  subtitleCell.alignment = { vertical: 'middle', horizontal: 'center' };

  // Información General
  let currentRow = 8;
  sheet1.getCell(`B${currentRow}`).value = 'DATOS DE LA PRESENTACIÓN';
  sheet1.getCell(`B${currentRow}`).font = { name: 'Segoe UI', size: 11, bold: true, color: { argb: colors.primaryMedium } };
  sheet1.mergeCells(`B${currentRow}:E${currentRow}`);
  currentRow++;

  const generalInfo = [
    ['Proyecto:', 'WashGo (Lavandería Móvil/Web)'],
    ['Propósito:', 'Presentación General / Negocio'],
    ['Esquema:', 'Simplificado (Entidades Core)'],
    ['Fecha:', new Date().toLocaleDateString('es-ES')],
  ];

  generalInfo.forEach(([label, val]) => {
    sheet1.getCell(`B${currentRow}`).value = label;
    sheet1.getCell(`B${currentRow}`).font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: colors.primaryLight } };
    sheet1.getCell(`C${currentRow}`).value = val;
    sheet1.getCell(`C${currentRow}`).font = { name: 'Segoe UI', size: 10 };
    sheet1.mergeCells(`C${currentRow}:E${currentRow}`);
    currentRow++;
  });

  // Leyenda de Llaves
  currentRow = 8;
  sheet1.getCell(`F${currentRow}`).value = 'NOMENCLATURA';
  sheet1.getCell(`F${currentRow}`).font = { name: 'Segoe UI', size: 11, bold: true, color: { argb: colors.primaryMedium } };
  sheet1.mergeCells(`F${currentRow}:H${currentRow}`);
  currentRow++;

  const legends = [
    ['PK', 'Llave Primaria', 'Identificador único'],
    ['FK', 'Llave Foránea', 'Relación con otra tabla'],
    ['*', 'Requerido', 'Campo obligatorio'],
  ];

  legends.forEach(([sigla, nombre, desc]) => {
    sheet1.getCell(`F${currentRow}`).value = sigla;
    sheet1.getCell(`F${currentRow}`).font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: sigla === 'PK' ? colors.pkColor : (sigla === 'FK' ? colors.fkColor : colors.primaryMedium) } };
    sheet1.getCell(`F${currentRow}`).alignment = { horizontal: 'center' };
    
    sheet1.getCell(`G${currentRow}`).value = nombre;
    sheet1.getCell(`G${currentRow}`).font = { name: 'Segoe UI', size: 9, bold: true };
    
    sheet1.getCell(`H${currentRow}`).value = desc;
    sheet1.getCell(`H${currentRow}`).font = { name: 'Segoe UI', size: 9, color: { argb: colors.textMuted } };
    currentRow++;
  });

  // Lista de Entidades Principales
  currentRow += 3;
  sheet1.getCell(`B${currentRow}`).value = 'ENTIDADES CLAVE (CORE)';
  sheet1.getCell(`B${currentRow}`).font = { name: 'Segoe UI', size: 12, bold: true, color: { argb: colors.primaryMedium } };
  sheet1.mergeCells(`B${currentRow}:H${currentRow}`);
  currentRow++;

  const summaryHeaders = ['Entidad', 'Descripción General', 'Campos Clave', 'Relaciones Principales'];
  summaryHeaders.forEach((h, idx) => {
    const col = String.fromCharCode(66 + idx * 2); // B, D, F, H...
    const cell = sheet1.getCell(`${col}${currentRow}`);
    cell.value = h;
    cell.font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: colors.white } };
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.primaryLight } };
    cell.alignment = { horizontal: 'center' };
    if (idx < 3) {
      sheet1.mergeCells(`${col}${currentRow}:${String.fromCharCode(66 + idx * 2 + 1)}${currentRow}`);
    }
  });
  currentRow++;

  const coreEntities = [
    ['User (Usuario)', 'Usuarios que interactúan en la app (clientes, empleados, administradores).', 'id, nombre, email, rol', 'Ninguna (Es la base)'],
    ['Business (Lavandería)', 'Establecimientos de lavanderías registrados.', 'id, ownerId, nombre, ruc', 'Dueño (User)'],
    ['BusinessEmployee (Empleado)', 'Vincula empleados a una lavandería.', 'id, businessId, employeeId', 'Lavandería, Empleado'],
    ['Service (Servicio)', 'Servicios ofrecidos por cada lavandería.', 'id, businessId, nombre, precio', 'Lavandería (Business)'],
    ['Order (Pedido)', 'Órdenes de servicio y estados de lavado.', 'id, businessId, clientId, serviceId', 'Lavandería, Cliente, Servicio'],
    ['Vehicle (Vehículo)', 'Vehículos del cliente para recojo y delivery.', 'id, clientId, marca, placa', 'Cliente (User)'],
  ];

  coreEntities.forEach(([name, desc, fields, rels]) => {
    sheet1.getCell(`B${currentRow}`).value = name;
    sheet1.getCell(`B${currentRow}`).font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: colors.accentTeal } };
    sheet1.mergeCells(`B${currentRow}:C${currentRow}`);
    
    sheet1.getCell(`D${currentRow}`).value = desc;
    sheet1.getCell(`D${currentRow}`).font = { name: 'Segoe UI', size: 9 };
    sheet1.mergeCells(`D${currentRow}:E${currentRow}`);
    
    sheet1.getCell(`F${currentRow}`).value = fields;
    sheet1.getCell(`F${currentRow}`).font = { name: 'Segoe UI', size: 9 };
    sheet1.getCell(`F${currentRow}`).alignment = { horizontal: 'center' };
    sheet1.mergeCells(`F${currentRow}:G${currentRow}`);

    sheet1.getCell(`H${currentRow}`).value = rels;
    sheet1.getCell(`H${currentRow}`).font = { name: 'Segoe UI', size: 9 };
    sheet1.getCell(`H${currentRow}`).alignment = { horizontal: 'center' };
    
    const cols = ['B', 'C', 'D', 'E', 'F', 'G', 'H'];
    cols.forEach(c => {
      sheet1.getCell(`${c}${currentRow}`).border = thinBorder;
      if (currentRow % 2 === 0) {
        sheet1.getCell(`${c}${currentRow}`).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.bgLight } };
      }
    });
    currentRow++;
  });

  sheet1.getColumn('B').width = 15;
  sheet1.getColumn('C').width = 15;
  sheet1.getColumn('D').width = 25;
  sheet1.getColumn('E').width = 25;
  sheet1.getColumn('F').width = 15;
  sheet1.getColumn('G').width = 15;
  sheet1.getColumn('H').width = 25;

  // -------------------------------------------------------------
  // PESTAÑA 2: ESTRUCTURA DE TABLAS & ATRIBUTOS
  // -------------------------------------------------------------
  const sheet2 = workbook.addWorksheet('2. Diccionario Simplificado');
  sheet2.views = [{ showGridLines: true }];

  sheet2.getCell('A1').value = 'TABLAS, ATRIBUTOS Y RELACIONES GENERALES';
  sheet2.getCell('A1').font = { name: 'Segoe UI', size: 16, bold: true, color: { argb: colors.primaryMedium } };
  sheet2.mergeCells('A1:G1');
  sheet2.getRow(1).height = 30;

  const dictHeaders = ['Entidad (Tabla)', 'Atributo (Campo)', 'Tipo de Dato', 'Rol Llave', '¿Requerido?', 'Vinculado a (Relación)', 'Descripción Funcional'];
  sheet2.getRow(3).values = dictHeaders;
  sheet2.getRow(3).height = 25;
  sheet2.getRow(3).font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: colors.white } };
  
  const dictCols = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  dictCols.forEach(col => {
    const cell = sheet2.getCell(`${col}3`);
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.primaryMedium } };
    cell.alignment = { vertical: 'middle', horizontal: 'center' };
    cell.border = headerBorder;
  });

  const simplifiedData = [
    // User
    { ent: 'User (Usuario)', field: 'id', type: 'String', key: 'PK', req: 'Sí', ref: '-', desc: 'Identificador único del usuario.' },
    { ent: 'User (Usuario)', field: 'nombreCompleto', type: 'String', key: '-', req: 'Sí', ref: '-', desc: 'Nombre y apellidos del usuario.' },
    { ent: 'User (Usuario)', field: 'email', type: 'String', key: 'Unique', req: 'Sí', ref: '-', desc: 'Correo electrónico.' },
    { ent: 'User (Usuario)', field: 'rol', type: 'Enum', key: '-', req: 'Sí', ref: '-', desc: 'Rol en la plataforma (Cliente, Empleado, Administrador).' },
    
    // Business
    { ent: 'Business (Lavandería)', field: 'id', type: 'UUID', key: 'PK', req: 'Sí', ref: '-', desc: 'Identificador único de la lavandería.' },
    { ent: 'Business (Lavandería)', field: 'ownerId', type: 'String', key: 'FK', req: 'Sí', ref: 'User(id)', desc: 'Identificador del dueño o administrador.' },
    { ent: 'Business (Lavandería)', field: 'nombre', type: 'String', key: '-', req: 'Sí', ref: '-', desc: 'Nombre comercial de la lavandería.' },
    { ent: 'Business (Lavandería)', field: 'ruc', type: 'String', key: 'Unique', req: 'Sí', ref: '-', desc: 'Documento fiscal RUC.' },

    // BusinessEmployee
    { ent: 'BusinessEmployee (Empleado)', field: 'id', type: 'UUID', key: 'PK', req: 'Sí', ref: '-', desc: 'Identificador del registro de trabajo.' },
    { ent: 'BusinessEmployee (Empleado)', field: 'businessId', type: 'UUID', key: 'FK', req: 'Sí', ref: 'Business(id)', desc: 'Negocio donde labora el empleado.' },
    { ent: 'BusinessEmployee (Empleado)', field: 'employeeId', type: 'String', key: 'FK', req: 'Sí', ref: 'User(id)', desc: 'Usuario que cumple el rol de empleado.' },
    { ent: 'BusinessEmployee (Empleado)', field: 'status', type: 'Enum', key: '-', req: 'Sí', ref: '-', desc: 'Estado laboral (Activo / Inactivo).' },

    // Service
    { ent: 'Service (Servicio)', field: 'id', type: 'UUID', key: 'PK', req: 'Sí', ref: '-', desc: 'Identificador único del servicio.' },
    { ent: 'Service (Servicio)', field: 'businessId', type: 'UUID', key: 'FK', req: 'Sí', ref: 'Business(id)', desc: 'Negocio que ofrece este servicio.' },
    { ent: 'Service (Servicio)', field: 'nombre', type: 'String', key: '-', req: 'Sí', ref: '-', desc: 'Nombre del servicio (ej. Lavado al seco).' },
    { ent: 'Service (Servicio)', field: 'precio', type: 'Float', key: '-', req: 'Sí', ref: '-', desc: 'Costo del servicio.' },

    // Order
    { ent: 'Order (Pedido)', field: 'id', type: 'UUID', key: 'PK', req: 'Sí', ref: '-', desc: 'Código único del pedido.' },
    { ent: 'Order (Pedido)', field: 'businessId', type: 'UUID', key: 'FK', req: 'Sí', ref: 'Business(id)', desc: 'Negocio que recibe el pedido.' },
    { ent: 'Order (Pedido)', field: 'clientId', type: 'String', key: 'FK', req: 'Sí', ref: 'User(id)', desc: 'Cliente que solicita el servicio.' },
    { ent: 'Order (Pedido)', field: 'employeeId', type: 'String', key: 'FK', req: 'No', ref: 'User(id)', desc: 'Empleado asignado al lavado (opcional).' },
    { ent: 'Order (Pedido)', field: 'serviceId', type: 'UUID', key: 'FK', req: 'Sí', ref: 'Service(id)', desc: 'Servicio principal seleccionado.' },
    { ent: 'Order (Pedido)', field: 'price', type: 'Float', key: '-', req: 'Sí', ref: '-', desc: 'Total cobrado en el pedido.' },
    { ent: 'Order (Pedido)', field: 'status', type: 'Enum', key: '-', req: 'Sí', ref: '-', desc: 'Estado de la orden (Pendiente, En Proceso, Completado).' },

    // Vehicle
    { ent: 'Vehicle (Vehículo)', field: 'id', type: 'UUID', key: 'PK', req: 'Sí', ref: '-', desc: 'Identificador del vehículo.' },
    { ent: 'Vehicle (Vehículo)', field: 'clientId', type: 'String', key: 'FK', req: 'Sí', ref: 'User(id)', desc: 'Cliente propietario del vehículo.' },
    { ent: 'Vehicle (Vehículo)', field: 'brandModel', type: 'String', key: '-', req: 'Sí', ref: '-', desc: 'Marca y modelo (ej. Toyota Yaris).' },
    { ent: 'Vehicle (Vehículo)', field: 'plate', type: 'String', key: '-', req: 'No', ref: '-', desc: 'Placa del vehículo.' },
  ];

  let currentDictRow = 4;
  let lastEntity = '';

  simplifiedData.forEach(row => {
    sheet2.getRow(currentDictRow).values = [row.ent, row.field, row.type, row.key, row.req, row.ref, row.desc];
    sheet2.getRow(currentDictRow).height = 20;

    const entCell = sheet2.getCell(`A${currentDictRow}`);
    const fieldCell = sheet2.getCell(`B${currentDictRow}`);
    const typeCell = sheet2.getCell(`C${currentDictRow}`);
    const keyCell = sheet2.getCell(`D${currentDictRow}`);
    const reqCell = sheet2.getCell(`E${currentDictRow}`);
    const refCell = sheet2.getCell(`F${currentDictRow}`);
    const descCell = sheet2.getCell(`G${currentDictRow}`);

    [entCell, fieldCell, typeCell, keyCell, reqCell, refCell, descCell].forEach(c => {
      c.font = { name: 'Segoe UI', size: 9.5 };
      c.border = thinBorder;
      c.alignment = { vertical: 'middle' };
    });

    entCell.font = { name: 'Segoe UI', size: 9.5, bold: true, color: { argb: colors.accentTeal } };
    fieldCell.font = { name: 'Segoe UI', size: 9.5, bold: true };
    
    keyCell.alignment = { vertical: 'middle', horizontal: 'center' };
    if (row.key === 'PK') {
      keyCell.font = { name: 'Segoe UI', size: 9.5, bold: true, color: { argb: colors.pkColor } };
    } else if (row.key === 'FK') {
      keyCell.font = { name: 'Segoe UI', size: 9.5, bold: true, color: { argb: colors.fkColor } };
    }

    reqCell.alignment = { vertical: 'middle', horizontal: 'center' };
    refCell.alignment = { vertical: 'middle', horizontal: 'center' };
    if (row.ref !== '-') {
      refCell.font = { name: 'Segoe UI', size: 9, italic: true, color: { argb: colors.fkColor } };
    }

    // Border separation by Entity
    if (row.ent !== lastEntity) {
      [entCell, fieldCell, typeCell, keyCell, reqCell, refCell, descCell].forEach(c => {
        c.border = {
          ...thinBorder,
          top: { style: 'medium', color: { argb: colors.primaryLight } }
        };
      });
      lastEntity = row.ent;
    }

    if (currentDictRow % 2 === 0) {
      [entCell, fieldCell, typeCell, keyCell, reqCell, refCell, descCell].forEach(c => {
        c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.bgLight } };
      });
    }

    currentDictRow++;
  });

  sheet2.getColumn('A').width = 25;
  sheet2.getColumn('B').width = 20;
  sheet2.getColumn('C').width = 18;
  sheet2.getColumn('D').width = 15;
  sheet2.getColumn('E').width = 15;
  sheet2.getColumn('F').width = 18;
  sheet2.getColumn('G').width = 50;


  // -------------------------------------------------------------
  // PESTAÑA 3: RELACIONES (VÍNCULOS)
  // -------------------------------------------------------------
  const sheet3 = workbook.addWorksheet('3. Relaciones Generales');
  sheet3.views = [{ showGridLines: true }];

  sheet3.getCell('A1').value = 'MATRIZ DE RELACIONES ENTRE ENTIDADES';
  sheet3.getCell('A1').font = { name: 'Segoe UI', size: 16, bold: true, color: { argb: colors.primaryMedium } };
  sheet3.mergeCells('A1:F1');
  sheet3.getRow(1).height = 30;

  const relHeaders = ['Entidad Origen', 'Atributo Llave', 'Entidad Destino', 'Tipo Relación', 'Descripción de Relación', 'Impacto'];
  sheet3.getRow(3).values = relHeaders;
  sheet3.getRow(3).height = 25;
  sheet3.getRow(3).font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: colors.white } };
  
  const relCols = ['A', 'B', 'C', 'D', 'E', 'F'];
  relCols.forEach(col => {
    const cell = sheet3.getCell(`${col}3`);
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.primaryMedium } };
    cell.alignment = { vertical: 'middle', horizontal: 'center' };
    cell.border = headerBorder;
  });

  const relationships = [
    { from: 'Business (Lavandería)', fk: 'ownerId', to: 'User (Usuario)', card: 'N : 1', desc: 'Un usuario del sistema es el dueño del negocio.', imp: 'Requerido' },
    { from: 'BusinessEmployee (Empleado)', fk: 'businessId', to: 'Business (Lavandería)', card: 'N : 1', desc: 'Vincula al empleado con su respectivo negocio.', imp: 'Requerido' },
    { from: 'BusinessEmployee (Empleado)', fk: 'employeeId', to: 'User (Usuario)', card: 'N : 1', desc: 'Identificador del usuario empleado asignado.', imp: 'Requerido' },
    { from: 'Service (Servicio)', fk: 'businessId', to: 'Business (Lavandería)', card: 'N : 1', desc: 'Lavandería asociada al servicio ofrecido.', imp: 'Requerido' },
    { from: 'Order (Pedido)', fk: 'businessId', to: 'Business (Lavandería)', card: 'N : 1', desc: 'Negocio que procesará el pedido.', imp: 'Requerido' },
    { from: 'Order (Pedido)', fk: 'clientId', to: 'User (Usuario)', card: 'N : 1', desc: 'Cliente creador de la orden de pedido.', imp: 'Requerido' },
    { from: 'Order (Pedido)', fk: 'employeeId', to: 'User (Usuario)', card: 'N : 1', desc: 'Empleado que ejecutará la orden.', imp: 'Opcional' },
    { from: 'Order (Pedido)', fk: 'serviceId', to: 'Service (Servicio)', card: 'N : 1', desc: 'Servicio contratado en el pedido.', imp: 'Requerido' },
    { from: 'Vehicle (Vehículo)', fk: 'clientId', to: 'User (Usuario)', card: 'N : 1', desc: 'Asocia el vehículo al cliente propietario.', imp: 'Requerido' },
  ];

  let currentRelRow = 4;
  relationships.forEach(rel => {
    sheet3.getRow(currentRelRow).values = [rel.from, rel.fk, rel.to, rel.card, rel.desc, rel.imp];
    sheet3.getRow(currentRelRow).height = 20;

    const fromCell = sheet3.getCell(`A${currentRelRow}`);
    const fkCell = sheet3.getCell(`B${currentRelRow}`);
    const toCell = sheet3.getCell(`C${currentRelRow}`);
    const cardCell = sheet3.getCell(`D${currentRelRow}`);
    const descCell = sheet3.getCell(`E${currentRelRow}`);
    const impCell = sheet3.getCell(`F${currentRelRow}`);

    [fromCell, fkCell, toCell, cardCell, descCell, impCell].forEach(c => {
      c.font = { name: 'Segoe UI', size: 9.5 };
      c.border = thinBorder;
      c.alignment = { vertical: 'middle' };
    });

    fromCell.font = { name: 'Segoe UI', size: 9.5, bold: true, color: { argb: colors.accentTeal } };
    toCell.font = { name: 'Segoe UI', size: 9.5, bold: true, color: { argb: colors.primaryMedium } };
    fkCell.font = { name: 'Segoe UI', size: 9.5, italic: true, color: { argb: colors.fkColor } };
    cardCell.alignment = { vertical: 'middle', horizontal: 'center' };
    cardCell.font = { name: 'Segoe UI', size: 9.5, bold: true };
    impCell.alignment = { vertical: 'middle', horizontal: 'center' };

    if (currentRelRow % 2 === 0) {
      [fromCell, fkCell, toCell, cardCell, descCell, impCell].forEach(c => {
        c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.bgLight } };
      });
    }

    currentRelRow++;
  });

  sheet3.getColumn('A').width = 25;
  sheet3.getColumn('B').width = 18;
  sheet3.getColumn('C').width = 25;
  sheet3.getColumn('D').width = 15;
  sheet3.getColumn('E').width = 50;
  sheet3.getColumn('F').width = 15;

  // Guardar archivo final
  const outputPath = path.join(__dirname, '..', 'WashGo_Base_de_Datos.xlsx');
  await workbook.xlsx.writeFile(outputPath);
  console.log(`Workbook updated successfully at: ${outputPath}`);
}

createDatabaseExcel().catch(console.error);
